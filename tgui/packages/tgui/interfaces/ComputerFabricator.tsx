import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

type ComputerFabricatorData = {
  state: number;
  devtype?: number;
  hw_cpu?: number;
  hw_battery?: number;
  hw_disk?: number;
  hw_netcard?: number;
  hw_tesla?: number;
  hw_nanoprint?: number;
  hw_card?: number;
  hw_aislot?: number;
  totalprice?: number;
};

const LAPTOP_CPU_OPTIONS = [
  { val: 1, label: 'Default (Atom, +0 cr)' },
  { val: 2, label: 'Upgraded (+199 cr)' },
];

const TABLET_CPU_OPTIONS = [
  { val: 1, label: 'Default (Atom Nano, +0 cr)' },
  { val: 2, label: 'Advanced (+299 cr)' },
];

const LAPTOP_BATTERY_OPTIONS = [
  { val: 1, label: 'Micro 500C (+0 cr)' },
  { val: 2, label: 'Basic 750C (+99 cr)' },
  { val: 3, label: 'Advanced 1100C (+499 cr)' },
];

const TABLET_BATTERY_OPTIONS = [
  { val: 1, label: 'Basic 300C (+0 cr)' },
  { val: 2, label: 'Upgraded 500C (+99 cr)' },
  { val: 3, label: 'Advanced 750C (+149 cr)' },
];

const LAPTOP_DISK_OPTIONS = [
  { val: 1, label: '32GQ (+0 cr)' },
  { val: 2, label: '128GQ (+99 cr)' },
  { val: 3, label: '256GQ (+299 cr)' },
];

const TABLET_DISK_OPTIONS = [
  { val: 1, label: '32GQ (+0 cr)' },
  { val: 2, label: '64GQ (+49 cr)' },
  { val: 3, label: '128GQ (+129 cr)' },
];

const LAPTOP_NETCARD_OPTIONS = [
  { val: 0, label: 'None (+0 cr)' },
  { val: 1, label: 'Short-Range (+99 cr)' },
  { val: 2, label: 'Long-Range (+299 cr)' },
];

const TABLET_NETCARD_OPTIONS = [
  { val: 0, label: 'None (+0 cr)' },
  { val: 1, label: 'Short-Range (+49 cr)' },
  { val: 2, label: 'Long-Range (+129 cr)' },
];

const HwRow = ({
  label,
  hwKey,
  current,
  options,
  act,
}: {
  label: string;
  hwKey: string;
  current: number;
  options: { val: number; label: string }[];
  act: any;
}) => (
  <LabeledList.Item label={label}>
    {options.map((opt) => (
      <Button
        key={opt.val}
        content={opt.label}
        selected={current === opt.val}
        onClick={() => act('set_hw', { hw: hwKey, val: opt.val })}
      />
    ))}
  </LabeledList.Item>
);

export const ComputerFabricator = (props, context) => {
  const { act, data } = useBackend<ComputerFabricatorData>(context);

  return (
    <Window
      title="Personal Computer Vendor"
      width={520}
      height={440}
      theme="ntos"
    >
      <Window.Content scrollable>
        {data.state === 0 && (
          <Section title="Select Device Type">
            <Button
              fluid
              mb={1}
              content="Laptop — Portable workstation (from 99 cr)"
              icon="laptop"
              onClick={() => act('pick_device', { devtype: 1 })}
            />
            <Button
              fluid
              mb={1}
              content="Tablet — Handheld computer (from 199 cr)"
              icon="tablet"
              onClick={() => act('pick_device', { devtype: 2 })}
            />
            <Button
              fluid
              content="PDA — Pocket device (from 199 cr)"
              icon="mobile"
              onClick={() => act('pick_device', { devtype: 3 })}
            />
          </Section>
        )}

        {data.state === 1 && (
          <>
            <Section
              title={
                data.devtype === 1
                  ? 'Configure Laptop'
                  : data.devtype === 2
                    ? 'Configure Tablet'
                    : 'Configure PDA'
              }
            >
              <LabeledList>
                <HwRow
                  label="CPU"
                  hwKey="cpu"
                  current={data.hw_cpu!}
                  options={
                    data.devtype === 1 ? LAPTOP_CPU_OPTIONS : TABLET_CPU_OPTIONS
                  }
                  act={act}
                />
                <HwRow
                  label="Battery"
                  hwKey="battery"
                  current={data.hw_battery!}
                  options={
                    data.devtype === 1
                      ? LAPTOP_BATTERY_OPTIONS
                      : TABLET_BATTERY_OPTIONS
                  }
                  act={act}
                />
                <HwRow
                  label="Storage"
                  hwKey="disk"
                  current={data.hw_disk!}
                  options={
                    data.devtype === 1
                      ? LAPTOP_DISK_OPTIONS
                      : TABLET_DISK_OPTIONS
                  }
                  act={act}
                />
                <HwRow
                  label="Network Card"
                  hwKey="netcard"
                  current={data.hw_netcard!}
                  options={
                    data.devtype === 1
                      ? LAPTOP_NETCARD_OPTIONS
                      : TABLET_NETCARD_OPTIONS
                  }
                  act={act}
                />
                {data.devtype === 1 && (
                  <LabeledList.Item label="Tesla Link">
                    <Button
                      content={
                        data.hw_tesla ? 'Installed (+399 cr)' : 'None (+0 cr)'
                      }
                      selected={!!data.hw_tesla}
                      onClick={() =>
                        act('set_hw', {
                          hw: 'tesla',
                          val: data.hw_tesla ? 0 : 1,
                        })
                      }
                    />
                  </LabeledList.Item>
                )}
                <LabeledList.Item label="Nano Printer">
                  <Button
                    content={
                      data.hw_nanoprint
                        ? `Installed (+${data.devtype === 1 ? 99 : 49} cr)`
                        : 'None (+0 cr)'
                    }
                    selected={!!data.hw_nanoprint}
                    onClick={() =>
                      act('set_hw', {
                        hw: 'nanoprint',
                        val: data.hw_nanoprint ? 0 : 1,
                      })
                    }
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Card Slot">
                  <Button
                    content={
                      data.hw_card ? 'Installed (+99 cr)' : 'None (+0 cr)'
                    }
                    selected={!!data.hw_card}
                    onClick={() =>
                      act('set_hw', { hw: 'card', val: data.hw_card ? 0 : 1 })
                    }
                  />
                </LabeledList.Item>
                <LabeledList.Item label="AI Slot">
                  <Button
                    content={
                      data.hw_aislot
                        ? `Installed (+${data.devtype === 1 ? 499 : 199} cr)`
                        : 'None (+0 cr)'
                    }
                    selected={!!data.hw_aislot}
                    onClick={() =>
                      act('set_hw', {
                        hw: 'aislot',
                        val: data.hw_aislot ? 0 : 1,
                      })
                    }
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Section>
              <Box fontSize="1.2em" bold mb={1}>
                Total: {data.totalprice} cr
              </Box>
              <Button
                icon="check"
                content="Confirm Order"
                color="good"
                onClick={() => act('confirm_order')}
              />
              <Button
                ml={1}
                icon="times"
                content="Cancel"
                color="bad"
                onClick={() => act('clean_order')}
              />
            </Section>
          </>
        )}

        {data.state === 2 && (
          <Section title="Payment">
            <NoticeBox>
              Order total:{' '}
              <Box bold as="span">
                {data.totalprice} credits
              </Box>
              <br />
              Swipe an ID card or use a credit chip to complete your purchase.
            </NoticeBox>
            <Button
              mt={1}
              icon="times"
              content="Cancel Order"
              color="bad"
              onClick={() => act('clean_order')}
            />
          </Section>
        )}

        {data.state === 3 && (
          <Section title="Thank You">
            <NoticeBox color="good">
              Your device has been dispensed. Have a NanoTrasen day!
            </NoticeBox>
            <Button
              mt={1}
              content="New Order"
              onClick={() => act('clean_order')}
            />
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
