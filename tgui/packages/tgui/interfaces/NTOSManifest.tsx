import { NtosWindow } from '../layouts';
import { Manifest } from './common/Manifest';

export const NTOSManifest = () => {
  return (
    <NtosWindow width={400} height={350}>
      <NtosWindow.Content>
        <Manifest />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
