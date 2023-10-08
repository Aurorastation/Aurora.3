import { BooleanLike } from '../../common/react';
import { capitalize } from '../../common/string';
import { useBackend } from '../backend';
import { Box, Button, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export type HarvesterData = {
  manufacturer: string;
  id: string;
  status: BooleanLike;
  materials: Material[];
};

type Material = {
  material: string;
  rawamount: number;
  amount: number;
  harvest: BooleanLike;
};

export const KineticHarvester = (props, context) => {
  const { act, data } = useBackend<HarvesterData>(context);

  return (
    <Window resizable theme={data.manufacturer}>
      <Window.Content scrollable>
        {data.id ? (
          <HarvestWindow />
        ) : (
          <NoticeBox>No fusion plant detected.</NoticeBox>
        )}
      </Window.Content>
    </Window>
  );
};

export const HarvestWindow = (props, context) => {
  const { act, data } = useBackend<HarvesterData>(context);

  return (
    <Section
      title="Fusion Plant Harvesting"
      buttons={
        <Button
          content={data.status ? 'Online' : 'Offline'}
          icon={data.status ? 'power-off' : 'times'}
          color={data.status ? 'good' : 'bad'}
          onClick={() => act('toggle_power')}
        />
      }>
      {data.status ? (
        data.materials && data.materials.length ? (
          data.materials.map((material) => (
            <Section
              title={
                capitalize(material.material) +
                ' (' +
                material.rawamount +
                ' cubic units)'
              }
              key={material.material}
              buttons={
                <Button
                  content={material.harvest ? 'Stop Harvesting' : 'Harvest'}
                  icon="arrow-circle-up"
                  color={material.harvest ? 'good' : 'bad'}
                  onClick={() =>
                    act('toggle_harvest', { toggle_harvest: material.material })
                  }
                />
              }>
              {material.harvest ? (
                material.amount ? (
                  <>
                    <Box as="span">
                      {material.amount}{' '}
                      {material.amount !== 1 ? 'sheets' : 'sheet'} ready.
                    </Box>
                    &nbsp;
                    <Button
                      content="Extract"
                      icon="compress-arrows-alt"
                      onClick={() =>
                        act('remove_mat', { remove_mat: material.material })
                      }
                    />
                  </>
                ) : (
                  <NoticeBox warning>
                    Not enough cubic units harvested.
                  </NoticeBox>
                )
              ) : (
                <NoticeBox danger>No cubic units harvested.</NoticeBox>
              )}
            </Section>
          ))
        ) : (
          <NoticeBox>No materials detected.</NoticeBox>
        )
      ) : (
        <NoticeBox>The harvester is offline.</NoticeBox>
      )}
    </Section>
  );
};
