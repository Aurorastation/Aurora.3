import { Window } from '../../layouts';
import { ManifestSection } from './ManifestSection';

export const Manifest = (props) => {
  return (
    <Window width={500} height={700}>
      <Window.Content scrollable>
        <ManifestSection />
      </Window.Content>
    </Window>
  );
};
