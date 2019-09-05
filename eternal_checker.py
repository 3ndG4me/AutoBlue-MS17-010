from mysmb import MYSMB
from impacket import smb, smbconnection, nt_errors
from impacket.uuid import uuidtup_to_bin
from impacket.dcerpc.v5.rpcrt import DCERPCException
from struct import pack
import sys
import argparse


'''
Script for
- check target if MS17-010 is patched or not.
- find accessible named pipe
'''


def check_ms17_010(conn):
    TRANS_PEEK_NMPIPE = 0x23
    recvPkt = conn.send_trans(pack('<H', TRANS_PEEK_NMPIPE), maxParameterCount=0xffff, maxDataCount=0x800)
    status = recvPkt.getNTStatus()
    if status == 0xC0000205:  # STATUS_INSUFF_SERVER_RESOURCES
        print('[!] The target is not patched')
    else:
        print('[-] The target is patched')
        sys.exit()

def check_accessible_pipes(conn):
    print('=== Testing named pipes ===')
    conn.find_named_pipe(firstOnly=False)

def main():
    parser = argparse.ArgumentParser()
    
    parser.add_argument('target', action='store',
    help='[[domain/]username[:password]@]<targetName or address>')

    group = parser.add_argument_group('connection')
    group.add_argument('-target-ip', action='store', metavar="ip address", 
    help='IP Address of the target machine. If ommited it will use whatever was specified as target. This is useful when target is the NetBIOS name and you cannot resolve it')
    group.add_argument('-port', choices=['139', '445'], nargs='?', default='445', metavar="destination port",
    help='Destination port to connect to SMB Server')

    if len(sys.argv)==1:
        parser.print_help()
        sys.exit(1)
    options = parser.parse_args()

    import re
    domain, username, password, remoteName = re.compile('(?:(?:([^/@:]*)/)?([^@:]*)(?::([^@]*))?@)?(.*)').match(options.target).groups('')

    #In case the password contains '@'
    if '@' in remoteName:
        password = password + '@' + remoteName.rpartition('@')[0]
        remoteName = remoteName.rpartition('@')[2]

    if domain is None:
        domain = ''

    if password == '' and username != '' and options.hashes is None and options.no_pass is False and options.aesKey is None:
        from getpass import getpass
        password = getpass("Password:")

    if options.target_ip is None:
        options.target_ip = remoteName

    conn = MYSMB(options.target_ip, int(options.port))
    try:
        conn.login(username, password)
    except smb.SessionError as e:
        print('[-] Login failed: ' + nt_errors.ERROR_MESSAGES[e.error_code][0])
        sys.exit()
    finally:
        print('[*] Target OS: ' + conn.get_server_os())

    tid = conn.tree_connect_andx('\\\\'+options.target_ip+'\\'+'IPC$')
    conn.set_default_tid(tid)

    check_ms17_010(conn)
    check_accessible_pipes(conn)

    conn.disconnect_tree(tid)
    conn.logoff()
    conn.get_socket().close()

    print('[*] Done')



main()