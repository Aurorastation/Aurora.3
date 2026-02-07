import { useBackend, useLocalState } from "../../backend";
import { Box, Button, Icon, Stack } from "../../components";
import { App, CommunicatorData, CommunicatorTab } from "./types";

export const CommunicatorHomeTab = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);

  const [currentTab, setCurrentTab] = useLocalState(context, 'tab', CommunicatorTab.Home);

  return (
    <Stack mt={2} wrap="wrap" align="center" justify="center">
      {apps.map((app) => (
        <Stack.Item
          basis="25%"
          textAlign="center"
          m={0}
          mb={2}
          key={app.name}
        >
            <Button
              style={{
                borderRadius: '10%',
                border: '1px solid #000',
              }}
              width="64px"
              height="64px"
              onClick={() => setCurrentTab(app.tab)}
            >
              <Icon
                name={app.icon}
                size={3}
                position="absolute"
                top="25%"
                left="25%"
              />
            </Button>
            <Box>{app.name}</Box>
        </Stack.Item>
      ))}
    </Stack>
  );
};

const PhoneApp: App = {
  name: "Phone",
  icon: "phone",
  tab: CommunicatorTab.Phone,
};

const ContactsApp: App = {
  name: "Contacts",
  icon: "user",
  tab: CommunicatorTab.Contacts,
};

const MessagingApp: App = {
  name: "Messaging",
  icon: "comment-alt",
  tab: CommunicatorTab.Messaging,
};

const SettingsApp: App = {
  name: "Settings",
  icon: "cog",
  tab: CommunicatorTab.Settings,
};

const apps = [
  PhoneApp,
  ContactsApp,
  MessagingApp,
  SettingsApp,
];
