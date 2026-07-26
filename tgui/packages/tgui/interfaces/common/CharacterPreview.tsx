import { ByondUi } from 'tgui-core/components';

type CharacterPreviewProps = {
  height: string;
  id: string;
  width?: string;
};

export const CharacterPreview = (props: CharacterPreviewProps) => {
  return (
    <ByondUi
      width={props.width ?? '220px'}
      height={props.height}
      params={{
        id: props.id,
        type: 'map',
      }}
    />
  );
};
