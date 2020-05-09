- `output.openVirtualPort("Node Output")` to create an instrument that DMXIS can listen to (DMXIS >> preferences)

- MIDI mappings in DMXIS

  file:/Library/Application Support/ENTTEC/DMXIS/Presets/DmxConfig.xml
  path:/DmxUniverse/MidiAssignments

    <Param name="1" val="-87" nrpn="-1" channel="1"/>
    144,41,0
    <Param name="2" val="-85" nrpn="-1" channel="1"/>
    144,43,0

- `node log.js` to display midi messages

- `coffee play.coffee` to send messages
