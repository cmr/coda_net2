package codanet

import (
	"net"

	mp "github.com/libp2p/go-mplex"          // Conn is a connection to a remote peer.
	smux "github.com/libp2p/go-stream-muxer" // Conn is a connection to a remote peer.
)

type conn struct {
	*mp.Multiplex
}

func (c *conn) Close() error {
	return c.Multiplex.Close()
}

func (c *conn) IsClosed() bool {
	return c.Multiplex.IsClosed()
}

// OpenStream creates a new stream.
func (c *conn) OpenStream() (smux.Stream, error) {
	return c.Multiplex.NewStream()
}

// AcceptStream accepts a stream opened by the other side.
func (c *conn) AcceptStream() (smux.Stream, error) {
	return c.Multiplex.Accept()
}

// MplexTransport is a go-peerstream transport that constructs
// multiplex-backed connections.
type MplexTransport struct{}

// DefaultMplexTransport has default settings for multiplex
var DefaultMplexTransport = &MplexTransport{}

// NewConn opens a new conn
func (t *MplexTransport) NewConn(nc net.Conn, isServer bool) (smux.Conn, error) {
	return &conn{mp.NewMultiplex(nc, isServer)}, nil
}
