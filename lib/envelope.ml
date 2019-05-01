module Sender = struct
  module Stable = struct
    module V1 = struct
      module T = struct
        type t = Local | Remote of Peer.Stable.V1.t
        [@@deriving sexp, bin_io]
      end

      include T
    end

    module Latest = V1

    module Module_decl = struct
      let name = "envelope_sender"

      type latest = Latest.t
    end

  end

  (* bin_io intentionally omitted in deriving list *)
  type t = Stable.Latest.t = Local | Remote of Peer.t
  [@@deriving sexp]
end

module Incoming = struct
  module Stable = struct
    module V1 = struct
      module T = struct
        type 'a t = {data: 'a; sender: Sender.Stable.V1.t}
        [@@deriving sexp, bin_io]
      end

      include T
    end

    module Latest = V1
  end

  (* bin_io intentionally omitted *)
  type 'a t = 'a Stable.Latest.t [@@deriving sexp]

  let sender t = t.Stable.Latest.sender

  let data t = t.Stable.Latest.data

  let wrap ~data ~sender = Stable.Latest.{data; sender}

  let map ~f t = Stable.Latest.{t with data= f t.data}

  let local data =
    let sender = Sender.Local in
    Stable.Latest.{data; sender}
end