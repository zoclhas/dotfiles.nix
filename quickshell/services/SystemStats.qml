pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property string cpuName: ""
  property real cpuUsage: 0
  property real cpuTemp: 0
  property real cpuFanRpm: 0
  property real gpuFanRpm: 0

  property real ramUsedGiB: 0
  property real ramTotalGiB: 0
  property real ramPercent: 0

  property var gpus: []

  property real diskAvailGiB: 0
  property real diskTotalGiB: 0
  property real diskPercent: 0

  property real _prevIdle: -1
  property real _prevTotal: -1

  function truncMiddle(str, max = 20) {
    if (!str || str.length <= max) return str ?? "";
    const avail = max - 3;
    const front = Math.ceil(avail / 2);
    const back = Math.floor(avail / 2);
    return str.slice(0, front) + "..." + str.slice(str.length - back);
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      cpuProc.running = true;
      ramProc.running = true;
      gpuProc.running = true;
      diskProc.running = true;
      sensorsProc.running = true;
      if (!root.cpuName) cpuNameProc.running = true;
    }
  }

  Process {
    id: cpuProc
    command: ["sh", "-c", "head -n1 /proc/stat"]
    stdout: StdioCollector {
      onStreamFinished: {
        const parts = text.trim().split(/\s+/).slice(1).map(Number);
        const idle = parts[3] + parts[4];
        const total = parts.reduce((a, b) => a + b, 0);
        if (root._prevTotal >= 0) {
          const dIdle = idle - root._prevIdle;
          const dTotal = total - root._prevTotal;
          if (dTotal > 0) root.cpuUsage = 100 * (1 - dIdle / dTotal);
        }
        root._prevIdle = idle;
        root._prevTotal = total;
      }
    }
  }

  Process {
    id: cpuNameProc
    command: ["sh", "-c", "awk -F': ' '/model name/{print $2; exit}' /proc/cpuinfo"]
    stdout: StdioCollector {
      onStreamFinished: root.cpuName = text.trim()
    }
  }

  Process {
    id: ramProc
    command: ["sh", "-c", "awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf \"%.2f %.2f %.1f\", (t-a)/1048576, t/1048576, 100*(t-a)/t}' /proc/meminfo"]
    stdout: StdioCollector {
      onStreamFinished: {
        const parts = text.trim().split(" ").map(Number);
        if (parts.length === 3) {
          root.ramUsedGiB = parts[0];
          root.ramTotalGiB = parts[1];
          root.ramPercent = parts[2];
        }
      }
    }
  }

  Process {
    id: gpuProc
    command: ["sh", "-c", "nvidia-smi --query-gpu=name,utilization.gpu,memory.used,memory.total,temperature.gpu --format=csv,noheader,nounits 2>/dev/null"]
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n").filter(l => l.length > 0);
        root.gpus = lines.map(line => {
          const parts = line.split(",").map(s => s.trim());
          return {
            name: parts[0] ?? "GPU",
            util: parseFloat(parts[1]) || 0,
            memUsedMiB: parseFloat(parts[2]) || 0,
            memTotalMiB: parseFloat(parts[3]) || 0,
            temp: parseFloat(parts[4]) || 0
          };
        });
      }
    }
  }

  Process {
    id: diskProc
    command: ["sh", "-c", "df -BG --output=avail,size / | tail -n1"]
    stdout: StdioCollector {
      onStreamFinished: {
        const parts = text.trim().split(/\s+/).map(s => parseFloat(s.replace("G", "")));
        if (parts.length === 2) {
          root.diskAvailGiB = parts[0];
          root.diskTotalGiB = parts[1];
          root.diskPercent = parts[1] > 0 ? 100 * (parts[1] - parts[0]) / parts[1] : 0;
        }
      }
    }
  }

  Process {
    id: sensorsProc
    command: ["sh", "-c", "sensors -j 2>/dev/null"]
    stdout: StdioCollector {
      onStreamFinished: {
        try {
          const data = JSON.parse(text);
          for (const chip in data) {
            if (chip.startsWith("k10temp") || chip.startsWith("coretemp")) {
              const fields = data[chip];
              for (const key in fields) {
                if (key === "Tctl" || key.startsWith("Package")) {
                  const vals = fields[key];
                  for (const k in vals) if (k.includes("input")) root.cpuTemp = vals[k];
                }
              }
            }
            if (chip.startsWith("asus")) {
              const fields = data[chip];
              for (const key in fields) {
                if (key.toLowerCase().includes("cpu_fan")) {
                  const vals = fields[key];
                  for (const k in vals) if (k.includes("input")) root.cpuFanRpm = vals[k];
                }
                if (key.toLowerCase().includes("gpu_fan")) {
                  const vals = fields[key];
                  for (const k in vals) if (k.includes("input")) root.gpuFanRpm = vals[k];
                }
              }
            }
          }
        } catch (e) {}
      }
    }
  }
}
