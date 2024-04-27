import { NtosWindow } from '../layouts';
import { ManifestSection } from './common/ManifestSection';

export const NTOSManifest = () => {
  return (
    <NtosWindow width={500} height={700}>
      <NtosWindow.Content scrollable>
        <ManifestSection />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
