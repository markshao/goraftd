package server

import (
	"github.com/hashicorp/raft"
)

type KvServer struct {
	serverID raft.ServerID

	// raft related
	raft     *raft.Raft
	logStore raft.LogStore
	ss       raft.StableStore
	trans    raft.Transport

	// fsm
}

func NewKvServer() *KvServer {

}
