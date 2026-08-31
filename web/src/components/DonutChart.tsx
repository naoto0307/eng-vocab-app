interface Segment {
  value: number;
  color: string;
}

interface DonutChartProps {
  segments: Segment[];
  size?: number;
  thickness?: number;
  centerValue: string;
  centerLabel: string;
}

export function DonutChart({ segments, size = 172, thickness = 22, centerValue, centerLabel }: DonutChartProps) {
  const total = segments.reduce((sum, s) => sum + s.value, 0);
  let angle = 0;
  const stops: string[] = [];
  if (total === 0) {
    stops.push('var(--gray-soft) 0deg 360deg');
  } else {
    for (const seg of segments) {
      const start = angle;
      const end = angle + (seg.value / total) * 360;
      stops.push(`${seg.color} ${start}deg ${end}deg`);
      angle = end;
    }
  }

  return (
    <div style={{ position: 'relative', width: size, height: size, flex: `0 0 ${size}px` }}>
      <div
        style={{
          width: size,
          height: size,
          borderRadius: '50%',
          background: `conic-gradient(${stops.join(', ')})`,
        }}
      />
      <div
        style={{
          position: 'absolute',
          inset: thickness,
          borderRadius: '50%',
          background: 'var(--bg-elevated)',
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
        }}
      >
        <div style={{ fontSize: 28, fontWeight: 900, letterSpacing: '-0.02em' }}>{centerValue}</div>
        <div style={{ fontSize: 12, color: 'var(--ink-faint)', fontWeight: 600 }}>{centerLabel}</div>
      </div>
    </div>
  );
}
