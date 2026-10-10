import type { ReactNode } from 'react';
import { Box, Stack } from 'tgui-core/components';

export type ActivityCardProps = {
  title: ReactNode;
  subtitle?: ReactNode;
  actions?: ReactNode;
  footer?: ReactNode;
  children?: ReactNode;
  accentColor?: string;
};

/**
 * A compact, theme-aware card for comments, messages, history, and audit logs.
 */
export const ActivityCard = (props: ActivityCardProps) => {
  const {
    title,
    subtitle,
    actions,
    footer,
    children,
    accentColor = 'var(--activity-card-accent, #4b82b4)',
  } = props;

  return (
    <Box
      backgroundColor="var(--activity-card-background, var(--section-background, rgba(10, 10, 10, 0.45)))"
      p={1}
      style={{ borderLeft: `3px solid ${accentColor}` }}
    >
      <Stack align="center">
        <Stack.Item grow>
          <Box bold>{title}</Box>
          {subtitle ? (
            <Box color="label" fontSize={0.9}>
              {subtitle}
            </Box>
          ) : null}
        </Stack.Item>
        {actions ? <Stack.Item>{actions}</Stack.Item> : null}
      </Stack>
      <Box
        backgroundColor="var(--activity-card-body-background, rgba(0, 0, 0, 0.3))"
        mt={1}
        p={1}
        style={{
          overflowWrap: 'anywhere',
          whiteSpace: 'pre-wrap',
        }}
      >
        {children}
      </Box>
      {footer ? (
        <Box color="label" fontSize={0.9} mt={0.5}>
          {footer}
        </Box>
      ) : null}
    </Box>
  );
};
