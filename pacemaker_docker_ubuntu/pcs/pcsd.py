import sys
import json

import usage
import utils

def pcsd_cmd(argv):
    if len(argv) == 0:
        usage.pcsd()
        sys.exit(1)

    sub_cmd = argv.pop(0)
    if sub_cmd == "help":
        usage.pcsd(argv)
    elif sub_cmd == "certkey":
        pcsd_certkey(argv)
    elif sub_cmd == "sync-certificates":
        pcsd_sync_certs(argv)
    else:
        usage.pcsd()
        sys.exit(1)

def pcsd_certkey(argv):
    if len(argv) != 2:
        usage.pcsd(["certkey"])
        exit(1)

    certfile = argv[0]
    keyfile = argv[1]

    try:
        with open(certfile, 'r') as myfile:
            cert = myfile.read()
    except IOError as e:
        utils.err(e)

    try:
        with open(keyfile, 'r') as myfile:
            key = myfile.read()
    except IOError as e:
        utils.err(e)

    if not "--force" in utils.pcs_options and (os.path.exists(settings.pcsd_cert_location) or os.path.exists(settings.pcsd_key_location)):
        utils.err("certificate and/or key already exists, your must use --force to overwrite")

    try:
        try:
            os.chmod(settings.pcsd_cert_location, 0700)
        except OSError: # If the file doesn't exist, we don't care
            pass

        try:
            os.chmod(settings.pcsd_key_location, 0700)
        except OSError: # If the file doesn't exist, we don't care
            pass

        with os.fdopen(os.open(settings.pcsd_cert_location, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0700), 'wb') as myfile:
            myfile.write(cert)

        with os.fdopen(os.open(settings.pcsd_key_location, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0700), 'wb') as myfile:
            myfile.write(key)

    except IOError as e:
        utils.err(e)

    print "Certificate and key updated, you may need to restart pcsd (service pcsd restart) for new settings to take effect"

def pcsd_sync_certs(argv):
    nodes = utils.getNodesFromCorosyncConf()
    print (
        "Synchronizing pcsd certificates on nodes {0}. pcsd needs to be "
        "restarted on the nodes in order to reload the certificates."
    ).format(", ".join(nodes))
    print
    pcsd_data = {'nodes': nodes}
    for cmd in ['send_local_certs', 'pcsd_restart_nodes']:
        error = ''
        output, retval = utils.run_pcsdcli(cmd, pcsd_data)
        if retval == 0 and output['status'] == 'ok' and output['data']:
            try:
                if output['data']['status'] != 'ok' and output['data']['text']:
                    error = output['data']['text']
            except KeyError:
                error = '201: Unable to communicate with pcsd'
        else:
            error = 'Unable to sync pcsd certificates'
        if error:
            utils.err(error, False)

