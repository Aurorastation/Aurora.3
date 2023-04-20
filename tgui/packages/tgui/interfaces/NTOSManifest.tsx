import { NtosWindow } from '../layouts';
import { Manifest } from './common/Manifest';

export const NTOSManifest = () => {
  return (
    <NtosWindow width={400} height={350}>
      <NtosWindow.Content scrollable>
        <Manifest />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
