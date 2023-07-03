import { NtosWindow } from '../layouts';
import { Manifest } from './common/Manifest';

export const NTOSManifest = () => {
  return (
    <NtosWindow width={500} height={700}>
      <NtosWindow.Content scrollable>
        <Manifest />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
