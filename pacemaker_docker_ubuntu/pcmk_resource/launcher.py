#!/usr/bin/env python
# -*- encoding: utf8 -*-

## @package gtm
#@brief  執行gtm啟動呼叫程序.
#@details  啟動停止以及檢視程序狀態是否符合.
#@authors Evan
#@version 0.1
#@date 2015-12-15

import os
import sys
import optparse

_user = "postgres"
_expect = "expect ./conf.expect xlcd1 %s 9.2 alpha"
_cmd = '/usr/local/pgsql/bin/gtm_ctl -Z'


getData = lambda tag, path: filter(
    lambda x: x.endswith(tag),
    map(
        lambda x: x.strip('\r\n'),
        os.popen(path).readlines()
    )
)

_settings = {
    'gtm': {'except': 'xlgtm', 'tag': 'gtm'}
}

##@brief ENTRY function.
#@param options: It's like a dictionary.
#@return 0
#@warning None
def main(options):
    _set = _settings[options.name]
    _env = 'cd %s;%s' % (options.dirpath, _expect % (_set['except'],))
    _path = getData(_set['tag'], _env)[0].split()[0]
    if len(_path) < 0: raise Exception('Can not get the path')
    getCMD = lambda act, tag: 'setuser %s %s %s %s -D %s' % (_user, _cmd, tag, act, _path)
    _CMD = lambda x: getCMD(x, options.name)
    if options.start:
        os.system(_CMD('start'))
    elif options.stop:
        print _CMD('stop')
    elif options.status:
	print _CMD('status')
        os.system(_CMD('status'))
    else:
        print 'Options: --(start|stop|status)'
    return 0

if __name__ == '__main__':
    #usage = "usage: %prog [options] arg1 arg2"
    #parser = optparse.OptionParser(usage=usage)
    parser = optparse.OptionParser(usage=main.__doc__)

    parser.add_option("--start", action="store_true",
                      help="Start process.",
                      dest="start", default=False)

    parser.add_option("--stop", action="store_true",
                      help="Stop process.",
                      dest="stop", default=False)

    parser.add_option("--status", action="store_true",
                      help="Check status.",
                      dest="status", default=False)

    parser.add_option("-d", "--dir", type="string",
                      help="Executing directory",
                      dest="dirpath")

    parser.add_option("-n", "--name", type="string",
                      help="Target Name",
                      dest="name", default="")

    #"""
    options, args = parser.parse_args()

    if len(args) != 0:
        parser.print_help()
        sys.exit(1)

    sys.exit(main(options))


