import { useLayoutEffect, useRef } from 'react';

type CharacterPreviewProps = {
  height: string;
  hidden?: boolean;
  id: string;
  width?: string;
};

export const CharacterPreview = (props: CharacterPreviewProps) => {
  const containerRef = useRef<HTMLDivElement>(null);

  useLayoutEffect(() => {
    const updateControl = () => {
      const container = containerRef.current;
      if (!container) {
        return;
      }
      const scale = window.devicePixelRatio ?? 1;
      const bounds = container.getBoundingClientRect();
      Byond.winset(props.id, {
        zoom: 1,
        'is-visible': !props.hidden,
        pos: `${bounds.left * scale},${bounds.top * scale}`,
        size: `${(bounds.right - bounds.left) * scale}x${(bounds.bottom - bounds.top) * scale}`,
      });
    };
    let resizeTimer: ReturnType<typeof setTimeout> | undefined;
    const updateOnResize = () => {
      if (resizeTimer !== undefined) {
        clearTimeout(resizeTimer);
      }
      resizeTimer = setTimeout(updateControl, 100);
    };
    window.addEventListener('resize', updateOnResize);
    updateControl();
    return () => {
      window.removeEventListener('resize', updateOnResize);
      if (resizeTimer !== undefined) {
        clearTimeout(resizeTimer);
      }
      // This skin-defined control belongs to Character Setup's reserved window.
      // Keep it in place while React suspends so reopening never recreates it.
    };
  }, [props.height, props.hidden, props.id, props.width]);

  return (
    <div
      ref={containerRef}
      style={{ height: props.height, width: props.width ?? '220px' }}
    >
      <div style={{ minHeight: '22px' }} />
    </div>
  );
};
