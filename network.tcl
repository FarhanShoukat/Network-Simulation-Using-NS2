set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam out.nam &
	exit 0
	}

$ns rtproto DV


for {set i 0} {$i < 14} {incr i} {
	set pc($i) [$ns node]
}

for {set i 0} {$i < 4} {incr i} {
	set router($i) [$ns node]
}

for {set i 0} {$i < 4} {incr i} {
	set center($i) [$ns node]
}


$ns duplex-link $pc(0) $router(0) 1.5Mb 10ms SFQ
$ns duplex-link $pc(1) $router(0) 1.5Mb 10ms SFQ
$ns duplex-link $pc(2) $router(0) 1.5Mb 10ms SFQ

$ns duplex-link $pc(3) $router(1) 1.5Mb 10ms SFQ
$ns duplex-link $pc(4) $router(1) 1.5Mb 10ms SFQ
$ns duplex-link $pc(5) $router(1) 1.5Mb 10ms SFQ
$ns duplex-link $pc(6) $router(1) 1.5Mb 10ms SFQ

$ns duplex-link $pc(7) $router(2) 1.5Mb 10ms SFQ
$ns duplex-link $pc(8) $router(2) 1.5Mb 10ms SFQ
$ns duplex-link $pc(9) $router(2) 1.5Mb 10ms SFQ

$ns duplex-link $pc(10) $router(3) 1.5Mb 10ms SFQ
$ns duplex-link $pc(11) $router(3) 1.5Mb 10ms SFQ
$ns duplex-link $pc(12) $router(3) 1.5Mb 10ms SFQ
$ns duplex-link $pc(13) $router(3) 1.5Mb 10ms SFQ

for {set i 0} {$i < 4} {incr i} {
	$ns duplex-link $router($i) $center($i) 1.5Mb 10ms SFQ
	$ns duplex-link $center($i) $center([expr [expr $i + 1] % 4]) 1.5Mb 10ms SFQ
}


$ns duplex-link-op $router(0) $pc(0) orient left-up
$ns duplex-link-op $router(0) $pc(1) orient up
$ns duplex-link-op $router(0) $pc(2) orient right-up

$ns duplex-link-op $router(1) $pc(3) orient right-up
$ns duplex-link-op $router(1) $pc(4) orient right
$ns duplex-link-op $router(1) $pc(5) orient right-down
$ns duplex-link-op $router(1) $pc(6) orient down

$ns duplex-link-op $router(2) $pc(7) orient right-down
$ns duplex-link-op $router(2) $pc(8) orient down
$ns duplex-link-op $router(2) $pc(9) orient left-down

$ns duplex-link-op $router(3) $pc(10) orient down
$ns duplex-link-op $router(3) $pc(11) orient left-down
$ns duplex-link-op $router(3) $pc(12) orient left-up
$ns duplex-link-op $router(3) $pc(13) orient up

$ns duplex-link-op $center(0) $center(1) orient right-down
$ns duplex-link-op $center(1) $center(2) orient left-down
$ns duplex-link-op $center(2) $center(3) orient left-up
$ns duplex-link-op $center(3) $center(0) orient right-up

$ns duplex-link-op $router(0) $center(0) orient right-up
$ns duplex-link-op $router(1) $center(1) orient left
$ns duplex-link-op $router(2) $center(2) orient up
$ns duplex-link-op $router(3) $center(3) orient right


set tcp1 [new Agent/TCP]
set tcp2 [new Agent/TCP]
set sin1 [new Agent/TCPSink]
set sin2 [new Agent/TCPSink]
set udp1 [new Agent/UDP]
set udp2 [new Agent/UDP]
set nul1 [new Agent/Null]
set nul2 [new Agent/Null]


set ftp1 [new Application/FTP]
set ftp2 [new Application/FTP]
set cbr1 [new Application/Traffic/CBR]
set cbr2 [new Application/Traffic/CBR]


$ns attach-agent $pc(2) $tcp1
$ns attach-agent $pc(8) $sin1
$ns connect $tcp1 $sin1
$ftp1 attach-agent $tcp1

$ns attach-agent $pc(4) $tcp2
$ns attach-agent $pc(11) $sin2
$ns connect $tcp2 $sin2
$ftp2 attach-agent $tcp2

$ns attach-agent $pc(12) $udp1
$ns attach-agent $pc(5) $nul1
$ns connect $udp1 $nul1
$cbr1 attach-agent $udp1
$cbr1 set packetSize_ 1.5Kb
$cbr1 set interval_ 44
$cbr1 set rate_ 2200

$ns attach-agent $pc(0) $udp2
$ns attach-agent $pc(7) $nul2
$ns connect $udp2 $nul2
$cbr2 attach-agent $udp2
$cbr1 set packetSize_ 5.5Kb
$cbr1 set interval_ 37
$cbr1 set rate_ 14800


$ns at 0.2 "$ftp1 start"
$ns at 1.8 "$ftp1 stop"

$ns at 0.3 "$ftp2 start"
$ns at 1.4 "$ftp2 stop"

$ns at 0.4 "$cbr1 start"
$ns at 1.6 "$cbr1 stop"

$ns at 0.7 "$cbr2 start"
$ns at 1.7 "$cbr2 stop"

$ns rtmodel-at 0.7 down $center(0) $center(1)
$ns rtmodel-at 1.0 up $center(0) $center(1)

$ns rtmodel-at 0.9 down $center(3) $center(2)
$ns rtmodel-at 1.3 up $center(3) $center(2)


$ns at 2.0 "finish"

$ns run