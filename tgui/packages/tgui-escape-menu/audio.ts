import { assetMap } from './assets';

let ambientAudio: HTMLAudioElement | null = null;

function getAssetUrl(name: string): string | null {
  return assetMap[name] ?? null;
}

function playOneShot(name: string, volume = 0.8) {
  const url = getAssetUrl(name);
  if (!url) return;
  const audio = new Audio(url);
  audio.volume = volume;
  audio.play().catch(() => {});
}

function startAmbient(name: string, volume = 0.8) {
  stopAmbient();
  const url = getAssetUrl(name);
  if (!url) return;
  ambientAudio = new Audio(url);
  ambientAudio.volume = volume;
  ambientAudio.play().catch(() => {});
}

function stopAmbient() {
  if (ambientAudio) {
    const audio = ambientAudio;
    ambientAudio = null;
    audio.pause();
  }
}

export function playOpenSounds() {
  playOneShot('esc_open.ogg', 0.25);
  startAmbient('esc_middle.ogg', 0.2);
}

export function playCloseSounds() {
  stopAmbient();
  playOneShot('esc_close.ogg', 0.25);
}

export function playLobbyButtonSound(sound: string) {
  playOneShot(sound);
}
