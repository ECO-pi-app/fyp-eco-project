import React from "react";
import Modal from "react-modal";
import ReactPlayer from "react-player";

Modal.setAppElement("#root");

export default function TrailerModal({ open, onClose, url }) {
  return (
    <Modal
      isOpen={open}
      onRequestClose={onClose}
      contentLabel="Trailer"
      style={{
        overlay: { backgroundColor: "rgba(0,0,0,0.7)", zIndex: 1000 },
        content: {
          maxWidth: "900px",
          width: "90%",
          height: "60vh",
          margin: "auto",
          padding: "12px",
          borderRadius: "12px",
          inset: "50% auto auto 50%",
          transform: "translate(-50%, -50%)",
        },
      }}
    >
      <div style={{ display: "flex", justifyContent: "flex-end" }}>
        <button onClick={onClose} style={{ fontSize: 18, cursor: "pointer" }}>
          ✕
        </button>
      </div>

      <div style={{ height: "calc(60vh - 50px)" }}>
        {open && (<ReactPlayer url={url} width="100%" height="100%" playing={false} controls/>)}

      </div>
    </Modal>
  );
}
