const { PollyClient, SynthesizeSpeechCommand } = require("@aws-sdk/client-polly");
const { S3Client, PutObjectCommand } = require("@aws-sdk/client-s3");

const pollyClient = new PollyClient({});
const s3Client = new S3Client({});

exports.handler = async (event) => {
  const text = event?.text;
  if (!text || typeof text !== "string") {
    return { statusCode: 400, body: JSON.stringify({ message: "Missing 'text'." }) };
  }

  const bucket = process.env.OUTPUT_BUCKET;

  const pollyResponse = await pollyClient.send(
    new SynthesizeSpeechCommand({
      Text: text,
      OutputFormat: "mp3",
      VoiceId: event.voiceId || "Joanna",
    })
  );

  if (!pollyResponse.AudioStream) throw new Error("No AudioStream from Polly");

  const audioBuffer = await streamToBuffer(pollyResponse.AudioStream);
  const key = `audio-${Date.now()}.mp3`;

  await s3Client.send(
    new PutObjectCommand({
      Bucket: bucket,
      Key: key,
      Body: audioBuffer,
      ContentType: "audio/mpeg",
      ContentLength: audioBuffer.length,
    })
  );

  return { statusCode: 200, body: JSON.stringify({ s3Key: key }) };
};

async function streamToBuffer(stream) {
  const chunks = [];
  for await (const chunk of stream) chunks.push(Buffer.from(chunk));
  return Buffer.concat(chunks);
}