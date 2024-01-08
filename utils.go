package main

import (
	"fmt"
	"net"
)

func GetPodIp() (pip string) {
	interfaces, err := net.Interfaces()
	if err != nil {
		panic(fmt.Sprintf("Unable to fetch network interfaces: %v\n", err))
	}

	for _, i := range interfaces {
		addrs, err := i.Addrs()
		if err != nil {
			fmt.Printf("Unable to fetch address for interface %v: %v\n", i.Name, err)
			continue
		}

		for _, addr := range addrs {
			var ip net.IP
			switch v := addr.(type) {
			case *net.IPNet:
				ip = v.IP
			case *net.IPAddr:
				ip = v.IP
			}

			if ip == nil {
				continue
			}

			// Check if the IP starts with "172" which is typical for Docker containers
			if len(ip.String()) >= 3 && ip.String()[:3] == "172" {
				pip = ip.String()
				return
			}
		}
	}
	return
}
