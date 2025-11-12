import { Button, Flex, LabeledList, Section } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import { BooleanLike } from 'tgui-core/react';

export type GeoScannerData = {
  scanned_item: string;
  scanned_item_desc: string;
  last_scan_data: string;
  scan_progress: number;
  scanning: BooleanLike;
  scanner_seal_integrity: number;
  scanner_rpm: number;
  scanner_temperature: number;
  coolant_usage_rage: number;
  unused_coolant_abs: number;
  unused_coolant_per: number;
  coolant_purity: number;
  optimal_wavelength: number;
  maser_wavelength: number;
  maser_efficient: number;
  radiation: number;
  t_left_radspike: number;
  rad_shield_on: BooleanLike;
};

export const RadiometricScanner = (props) => {
  const { act, data } = useBackend<GeoScannerData>();

  return (
    <Window width={321} height={132}>
      <Window.Content>
        <Flex direction="row" align="stretch">
          <Flex.Item grow={1}>
            <Section fill title="Oxygen Tanks">
              <LabeledList>
                <LabeledList.Item label="Inventory">
                  {data.tanks_oxygen ? data.tanks_oxygen : 'NO TANKS'}
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button
                    content="Dispense"
                    disabled={data.tanks_oxygen === 0}
                    onClick={() => act('dispense_oxygen')}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Flex.Item>
          <Flex.Item grow={1}>
            <Section fill title="Phoron Tanks">
              <LabeledList>
                <LabeledList.Item label="Inventory">
                  {data.tanks_phoron ? data.tanks_phoron : 'NO TANKS'}
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button
                    content="Dispense"
                    disabled={data.tanks_phoron === 0}
                    onClick={() => act('dispense_phoron')}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};
