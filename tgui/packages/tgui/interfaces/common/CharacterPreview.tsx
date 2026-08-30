import { ByondUi } from 'tgui-core/components';
import { useEffect } from 'react';

type CharacterPreviewProps = {
  height: string;
  hidden?: boolean;
  id: string;
  width?: string;
};

export const CharacterPreview = (props: CharacterPreviewProps) => {
  useEffect(() => {
    Byond.winset(props.id, {
      'is-visible': !props.hidden,
    });
  }, [props.hidden, props.id]);

  return (
    <ByondUi
      width={props.width ?? '220px'}
      height={props.height}
      params={{
        id: props.id,
        'is-visible': !props.hidden,
        type: 'map',
        zoom: 1,
      }}
    />
  );
};
