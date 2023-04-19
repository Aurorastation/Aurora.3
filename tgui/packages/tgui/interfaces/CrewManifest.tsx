import { Window } from '../layouts';
import { Manifest } from './common/Manifest';

export const CrewManifest = () => {
  return (
    <Window>
      <Window.Content scrollable>
        <Manifest />
      </Window.Content>
    </Window>
  );
};
