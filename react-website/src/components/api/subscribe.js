import crypto from "crypto";

export default async function handler(req, res) {
  if (req.method !== "POST") return res.status(405).json({ error: "POST only" });

  const { email } = req.body || {};
  if (!email || typeof email !== "string")
    return res.status(400).json({ error: "Email is required" });

  const API_KEY = process.env.MAILCHIMP_API_KEY;      // xxxx-us16
  const AUDIENCE_ID = process.env.MAILCHIMP_AUDIENCE_ID;

  if (!API_KEY || !AUDIENCE_ID)
    return res.status(500).json({ error: "Server not configured" });

  const DC = API_KEY.split("-")[1]; // us16
  const hash = crypto.createHash("md5").update(email.toLowerCase()).digest("hex");

  const url = `https://${DC}.api.mailchimp.com/3.0/lists/${AUDIENCE_ID}/members/${hash}`;

  const mcRes = await fetch(url, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Basic ${Buffer.from("any:" + API_KEY).toString("base64")}`,
    },
    body: JSON.stringify({
      email_address: email,
      status_if_new: "subscribed", // change to "pending" for double opt-in
    }),
  });

  const data = await mcRes.json();
  if (!mcRes.ok) return res.status(400).json({ error: data?.detail || "Mailchimp error" });

  return res.status(200).json({ ok: true });
}
