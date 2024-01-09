package server

import (
	"github.com/hashicorp/raft"
	"io"
)

type KvFsm struct {
}

func (fsm *KvFsm) Apply(log *raft.Log) interface{} {

}

func (fsm *KvFsm) Snapshot() (raft.FSMSnapshot, error) {

}

func (fsm *KvFsm) Restore(snapshot io.ReadCloser) error {

}
