#!/usr/bin/pash
param(
	$cluster, $dexxpath
)


. cluster-gen-cluster.ps1 $cluster $dexxpath

$authnode = $htHosts |?{$_.role -ne "docker"}| %{$_.hostname}

$nid = 1
$nodelist = $authnode | %{
"
    node {
        ring0_addr: $_
        nodeid: $nid
    }
"
    $nid++
}

$ip = ($htHosts | ?{$_.hostname -eq (gc "/whoami")}).ip

"
totem {
    version: 2
    secauth: off
    cluster_name: docker
    transport: udpu
    # How long before declaring a token lost (ms)
    token:          5000

    # How many token retransmits before forming a new configuration
    token_retransmits_before_loss_const: 10

    # How long to wait for join messages in the membership protocol (ms)
    join:           1000

    # How long to wait for consensus to be achieved before starting a new
    # round of membership configuration (ms)
    consensus:      6000

    # Turn off the virtual synchrony filter
    vsftype:        none

    # Number of messages that may be sent by one processor on receipt of the token
    max_messages:   20

    # Stagger sending the node join messages by 1..send_join ms
    send_join: 45

    # Limit generated nodeids to 31-bits (positive signed integers)
    clear_node_high_bit: yes

    # Disable encryption
    secauth:        off

    # How many threads to use for encryption/decryption
    threads:           0

    interface {
            ringnumber: 0
            bindnetaddr: $ip
            mcastaddr: 226.94.1.1
            mcastport: 4000
    }
}

nodelist {
$nodelist
}

quorum {
    provider: corosync_votequorum
}

logging {
    to_logfile: yes
    logfile: /var/log/cluster/corosync.log
    to_syslog: yes
}
" | out-file  -Encoding ascii /etc/corosync/corosync.conf


