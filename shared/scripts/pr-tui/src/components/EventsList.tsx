import React, { useState, useEffect } from "react";
import { Box, Text } from "ink";
import { readEvents } from "../lib/events.js";

interface EventsListProps {
  refreshSignal?: number;
}

function getEventColor(event: string): string {
  if (event.includes("Deleted")) return "red";
  if (event.includes("Removed")) return "red";
  if (event.includes("Killed")) return "yellow";
  if (event.includes("Created")) return "green";
  if (event.includes("Opened")) return "cyan";
  return "white";
}

export function EventsList({ refreshSignal = 0 }: EventsListProps) {
  const [events, setEvents] = useState<string[]>([]);

  useEffect(() => {
    setEvents(readEvents(100));
  }, [refreshSignal]);

  if (events.length === 0) {
    return <Text dimColor>No events recorded</Text>;
  }

  return (
    <Box flexDirection="column">
      {events.map((event, i) => (
        <Box key={i} flexDirection="column" marginBottom={1}>
          <Text color={getEventColor(event) as any}>{event}</Text>
        </Box>
      ))}
    </Box>
  );
}
