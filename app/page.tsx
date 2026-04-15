"use client";

import { useState } from "react";

const INSTALL_CMD = `bash <(curl -sL SITE_URL/downloads/install.sh)`;

export default function Home() {
  const [copied, setCopied] = useState(false);
  const siteUrl =
    typeof window !== "undefined" ? window.location.origin : "";
  const cmd = INSTALL_CMD.replace("SITE_URL", siteUrl);

  const copy = () => {
    navigator.clipboard.writeText(cmd);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <main className="gradient-bg min-h-screen relative overflow-hidden">
      {/* Ambient orbs */}
      <div className="absolute top-1/4 -left-32 w-96 h-96 bg-purple-600/10 rounded-full blur-[128px]" />
      <div className="absolute bottom-1/4 -right-32 w-96 h-96 bg-blue-600/10 rounded-full blur-[128px]" />
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] bg-indigo-600/5 rounded-full blur-[200px]" />

      <div className="relative z-10 flex flex-col items-center justify-center min-h-screen px-6 py-20">
        {/* Logo / Title */}
        <div className="float-anim mb-4">
          <div className="w-20 h-20 rounded-2xl bg-gradient-to-br from-purple-500 to-blue-600 flex items-center justify-center shadow-2xl shadow-purple-500/20">
            <span className="text-3xl font-black">A</span>
          </div>
        </div>

        <h1 className="text-5xl md:text-7xl font-black tracking-tight mb-3 bg-gradient-to-r from-white via-purple-200 to-blue-200 bg-clip-text text-transparent">
          AlexSploit
        </h1>

        <p className="text-zinc-400 text-lg md:text-xl mb-2">
          ARM64 macOS Roblox Executor
        </p>
        <p className="text-zinc-600 text-sm mb-12">Apple Silicon Only</p>

        {/* Install command */}
        <div className="w-full max-w-2xl mb-10">
          <p className="text-xs text-zinc-500 uppercase tracking-widest mb-3 text-center">
            One-command install
          </p>
          <div
            onClick={copy}
            className="glass rounded-xl px-6 py-4 cursor-pointer hover:border-purple-500/30 transition-all group"
          >
            <div className="flex items-center justify-between gap-4">
              <code className="text-sm md:text-base text-purple-300 font-mono truncate">
                {cmd}
              </code>
              <span className="shrink-0 text-xs text-zinc-500 group-hover:text-purple-400 transition-colors">
                {copied ? "Copied!" : "Click to copy"}
              </span>
            </div>
          </div>
        </div>

        {/* Feature cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 w-full max-w-3xl mb-14">
          <Card
            icon="⚡"
            title="One Command"
            desc="Downloads, injects, and launches automatically"
          />
          <Card
            icon="🛡️"
            title="Codesigned"
            desc="Ad-hoc signed with entitlements preserved"
          />
          <Card
            icon="🖥️"
            title="Native App"
            desc="Full executor UI with script editor"
          />
        </div>

        {/* Download buttons */}
        <div className="flex flex-col sm:flex-row gap-3 mb-16">
          <a
            href="/downloads/AlexSploit-1.0.0-arm64.dmg"
            className="px-8 py-3 rounded-xl bg-gradient-to-r from-purple-600 to-blue-600 font-semibold text-sm hover:opacity-90 transition-opacity shadow-lg shadow-purple-500/20 text-center"
          >
            Download App (.dmg)
          </a>
          <a
            href="/downloads/libAlexSploit.dylib"
            className="px-8 py-3 rounded-xl glass font-semibold text-sm hover:border-purple-500/30 transition-all text-center"
          >
            Download Dylib
          </a>
          <a
            href="/downloads/install.sh"
            className="px-8 py-3 rounded-xl glass font-semibold text-sm hover:border-purple-500/30 transition-all text-center"
          >
            install.sh
          </a>
        </div>

        {/* Steps */}
        <div className="w-full max-w-xl">
          <h2 className="text-sm text-zinc-500 uppercase tracking-widest mb-6 text-center">
            How it works
          </h2>
          <div className="space-y-4">
            <Step n={1} text="Run the install command in Terminal" />
            <Step n={2} text="Script downloads Roblox + AlexSploit" />
            <Step n={3} text="Dylib is injected and app is codesigned" />
            <Step n={4} text="Roblox launches — open AlexSploit app to execute" />
          </div>
        </div>

        {/* Footer */}
        <div className="mt-20 text-zinc-700 text-xs">
          AlexSploit v1.0.0 · ARM64 · Use an alt account
        </div>
      </div>
    </main>
  );
}

function Card({
  icon,
  title,
  desc,
}: {
  icon: string;
  title: string;
  desc: string;
}) {
  return (
    <div className="glass rounded-xl p-5 hover:border-purple-500/20 transition-all">
      <div className="text-2xl mb-2">{icon}</div>
      <h3 className="font-semibold text-sm mb-1">{title}</h3>
      <p className="text-zinc-500 text-xs">{desc}</p>
    </div>
  );
}

function Step({ n, text }: { n: number; text: string }) {
  return (
    <div className="flex items-center gap-4">
      <div className="w-8 h-8 rounded-full bg-gradient-to-br from-purple-600/20 to-blue-600/20 border border-purple-500/20 flex items-center justify-center text-xs font-bold text-purple-400 shrink-0">
        {n}
      </div>
      <p className="text-zinc-400 text-sm">{text}</p>
    </div>
  );
}
