import { useBackend } from '../backend';
import { Box, Button, Divider, Flex, Grid, Input, NoticeBox, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export const MechpadControl = (props, context) => {
  const { topLevel } = props;
  const { act, data } = useBackend(context);
  const {
    pad_name,
    connected_mechpad,
  } = data;
  return (
    <Section
      title={(
        <Input
          value={pad_name}
          width="240px"
          onChange={(e, value) => act('rename', {
            name: value,
          })} />
      )}
      level={topLevel ? 1 : 2}
      buttons={(
        <Button
          icon="times"
          content="Удалить"
          color="bad"
          onClick={() => act('remove')} />
      )}>
      {!connected_mechpad && (
        <Box color="bad" textAlign="center">
          Не обнаружена платформа.
        </Box>
      ) || (
        <Button
          fluid
          icon="upload"
          content="Запустить"
          textAlign="center"
          onClick={() => act('launch')} />
      )}
    </Section>
  );
};

export const MechpadConsole = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    mechpads = [],
    selected_id,
  } = data;
  return (
    <Window
      width={555}
      height={125}>
      <Window.Content>
        {mechpads.length === 0 && (
          <NoticeBox>
            Не подключена платформа.
          </NoticeBox>
        ) || (
          <Section>
            <Flex minHeight="70px">
              <Flex.Item width="190px" minHeight="70px">
                {mechpads.map(mechpad => (
                  <Button
                    fluid
                    ellipsis
                    key={mechpad.name}
                    content={mechpad.name}
                    selected={selected_id === mechpad.id}
                    onClick={() => act('select_pad', {
                      id: mechpad.id,
                    })} />
                ))}
              </Flex.Item>
              <Flex.Item minHeight="100%">
                <Divider vertical />
              </Flex.Item>
              <Flex.Item grow={1} basis={0} minHeight="100%">
                {selected_id && (
                  <MechpadControl />
                ) || (
                  <Box>
                    Выбрать платформу.
                  </Box>
                )}
              </Flex.Item>
            </Flex>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
