import { Box } from 'tgui-core/components';

export type MedicalSeverity =
  | 'nominal'
  | 'minor'
  | 'moderate'
  | 'severe'
  | 'critical';

type MedicalMetric = {
  label: string;
  value: string | number;
  severity?: MedicalSeverity;
  onClick?: () => void;
};

type MedicalSummaryProps = {
  name: string | null;
  subtitle?: string | null;
  metrics: MedicalMetric[];
};

export const MedicalSummary = (props: MedicalSummaryProps) => (
  <Box className="MedicalSummary">
    <Box className="MedicalSummary__identity">
      <Box className="MedicalSummary__name">
        {props.name || 'Unknown patient'}
      </Box>
      {!!props.subtitle && (
        <Box className="MedicalSummary__subtitle">{props.subtitle}</Box>
      )}
    </Box>
    {props.metrics.map((metric) => {
      const content = (
        <>
          <Box className="MedicalSummary__metric-label">{metric.label}</Box>
          <Box className="MedicalSummary__metric-value">{metric.value}</Box>
        </>
      );
      const className = [
        'MedicalSummary__metric',
        `MedicalSeverity--${metric.severity || 'nominal'}`,
        metric.onClick && 'MedicalSummary__metric--interactive',
      ]
        .filter(Boolean)
        .join(' ');

      return metric.onClick ? (
        <button
          type="button"
          className={className}
          key={metric.label}
          onClick={metric.onClick}
        >
          {content}
        </button>
      ) : (
        <Box className={className} key={metric.label}>
          {content}
        </Box>
      );
    })}
  </Box>
);

export const getStandardSeverity = (
  value: number,
  maximum = 100,
  higherIsWorse = true,
): MedicalSeverity => {
  const ratio = maximum > 0 ? value / maximum : 0;
  const severityRatio = higherIsWorse ? ratio : 1 - ratio;
  if (severityRatio >= 0.75) return 'critical';
  if (severityRatio >= 0.5) return 'severe';
  if (severityRatio >= 0.25) return 'moderate';
  if (severityRatio > 0) return 'minor';
  return 'nominal';
};

export const standardizeSeverityLabel = (value: string | number) => {
  const normalized = String(value).toLowerCase();
  if (['none', 'healthy', 'undamaged', 'fine', 'nominal'].includes(normalized)) {
    return 'Nominal';
  }
  if (normalized === 'minor') return 'Minor';
  if (['moderate', 'significant'].includes(normalized)) return 'Moderate';
  if (['severe', 'extreme'].includes(normalized)) return 'Severe';
  if (['critical', 'irreparable', 'destroyed'].includes(normalized)) {
    return 'Critical';
  }
  return String(value);
};
