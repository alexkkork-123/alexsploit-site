"use client";

import { useState } from "react";

const INSTALL_CMD = `bash <(curl -sL https://alexsploit.com/downloads/install.sh)`;

export default function Home() {
  const [copied, setCopied] = useState(false);

  const copy = () => {
    navigator.clipboard.writeText(INSTALL_CMD);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <main className="relative min-h-screen overflow-hidden noise">
      {/* Subtle bg glow */}
      <div className="absolute top-[-20%] left-1/2 -translate-x-1/2 w-[800px] h-[500px] bg-violet-600/8 rounded-full blur-[160px] pulse-slow pointer-events-none" />
      <div className="absolute bottom-[-10%] right-[-10%] w-[400px] h-[400px] bg-violet-900/10 rounded-full blur-[120px] pointer-events-none" />

      <div className="relative z-10 max-w-2xl mx-auto px-6 pt-32 pb-20">
        {/* Header */}
        <div className="mb-16">
          <div className="flex items-center gap-3 mb-6">
            <div className="w-10 h-10 rounded-lg bg-violet-600 flex items-center justify-center text-sm font-bold tracking-tight">
              AS
            </div>
            <span className="text-zinc-600 text-sm font-mono">v1.0.0</span>
          </div>

          <h1 className="text-4xl md:text-5xl font-bold tracking-tight text-white mb-4">
            AlexSploit
          </h1>
          <p className="text-zinc-500 text-base leading-relaxed max-w-md">
            ARM64 macOS executor for Apple Silicon. One command to download,
            inject, and launch.
          </p>
        </div>

        {/* Terminal block */}
        <div className="mb-14">
          <div className="rounded-lg border border-zinc-800 bg-zinc-950 overflow-hidden">
            <div className="flex items-center gap-1.5 px-4 py-2.5 border-b border-zinc-800/60">
              <div className="w-2.5 h-2.5 rounded-full bg-zinc-800" />
              <div className="w-2.5 h-2.5 rounded-full bg-zinc-800" />
              <div className="w-2.5 h-2.5 rounded-full bg-zinc-800" />
              <span className="ml-2 text-[11px] text-zinc-600 font-mono">
                terminal
              </span>
            </div>
            <div
              onClick={copy}
              className="px-4 py-4 cursor-pointer group hover:bg-zinc-900/50 transition-colors"
            >
              <div className="flex items-center justify-between gap-4">
                <code className="text-[13px] text-zinc-300 font-mono leading-relaxed">
                  <span className="text-violet-400">$</span>{" "}
                  {INSTALL_CMD}
                </code>
                <span className="shrink-0 text-[11px] text-zinc-700 group-hover:text-violet-400 transition-colors font-mono">
                  {copied ? "copied" : "copy"}
                </span>
              </div>
            </div>
          </div>
        </div>

        {/* Downloads */}
        <div className="mb-14">
          <h2 className="text-xs text-zinc-600 font-mono uppercase tracking-wider mb-4">
            Downloads
          </h2>
          <div className="space-y-2">
            <DownloadRow
              href="/downloads/AlexSploit-1.0.0-arm64.dmg"
              name="AlexSploit-1.0.0-arm64.dmg"
              size="87 MB"
              primary
            />
            <DownloadRow
              href="/downloads/libAlexSploit.dylib"
              name="libAlexSploit.dylib"
              size="15 MB"
            />
            <DownloadRow
              href="/downloads/install.sh"
              name="install.sh"
              size="9 KB"
            />
          </div>
        </div>

        {/* Info */}
        <div className="mb-14">
          <h2 className="text-xs text-zinc-600 font-mono uppercase tracking-wider mb-4">
            How it works
          </h2>
          <div className="space-y-3 text-sm text-zinc-500 leading-relaxed">
            <div className="flex gap-3">
              <span className="text-zinc-700 font-mono text-xs mt-0.5 shrink-0">
                01
              </span>
              <p>Run the command above in Terminal</p>
            </div>
            <div className="flex gap-3">
              <span className="text-zinc-700 font-mono text-xs mt-0.5 shrink-0">
                02
              </span>
              <p>Downloads the pinned Roblox version + AlexSploit dylib</p>
            </div>
            <div className="flex gap-3">
              <span className="text-zinc-700 font-mono text-xs mt-0.5 shrink-0">
                03
              </span>
              <p>Injects the dylib, codesigns, and launches Roblox</p>
            </div>
            <div className="flex gap-3">
              <span className="text-zinc-700 font-mono text-xs mt-0.5 shrink-0">
                04
              </span>
              <p>Open the AlexSploit app from Applications to execute scripts</p>
            </div>
          </div>
        </div>

        {/* Requirements */}
        <div className="mb-20">
          <h2 className="text-xs text-zinc-600 font-mono uppercase tracking-wider mb-4">
            Requirements
          </h2>
          <div className="flex flex-wrap gap-2">
            <Tag text="Apple Silicon" />
            <Tag text="macOS 11+" />
            <Tag text="Xcode CLT" />
          </div>
        </div>

        {/* Footer */}
        <div className="border-t border-zinc-900 pt-6 flex items-center justify-between">
          <span className="text-zinc-700 text-xs font-mono">alexsploit</span>
          <span className="text-zinc-800 text-xs">use an alt account</span>
        </div>
      </div>
    </main>
  );
}

function DownloadRow({
  href,
  name,
  size,
  primary,
}: {
  href: string;
  name: string;
  size: string;
  primary?: boolean;
}) {
  return (
    <a
      href={href}
      className={`flex items-center justify-between px-4 py-3 rounded-lg border transition-colors group ${
        primary
          ? "border-violet-600/30 bg-violet-600/5 hover:bg-violet-600/10"
          : "border-zinc-800/60 hover:border-zinc-700 hover:bg-zinc-900/40"
      }`}
    >
      <div className="flex items-center gap-3">
        <svg
          className={`w-4 h-4 ${primary ? "text-violet-400" : "text-zinc-600"}`}
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
          strokeWidth={2}
        >
          <path
            strokeLinecap="round"
            strokeLinejoin="round"
            d="M12 4v12m0 0l-4-4m4 4l4-4M4 18h16"
          />
        </svg>
        <span
          className={`text-sm font-mono ${
            primary ? "text-violet-300" : "text-zinc-400"
          }`}
        >
          {name}
        </span>
      </div>
      <span className="text-xs text-zinc-600 font-mono">{size}</span>
    </a>
  );
}

function Tag({ text }: { text: string }) {
  return (
    <span className="px-3 py-1 rounded-md bg-zinc-900 border border-zinc-800 text-zinc-500 text-xs font-mono">
      {text}
    </span>
  );
}
