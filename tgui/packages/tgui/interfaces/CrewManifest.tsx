import { Window } from '../layouts';
import { ManifestSection } from './common/ManifestSection';

export const CrewManifest = () => {
  return (
    <Window title="Crew Manifest" width={500} height={700}>
      <Window.Content scrollable>
        <ManifestSection />
      </Window.Content>
    </Window>
  );
};
