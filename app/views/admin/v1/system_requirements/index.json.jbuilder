json.system_requirements do
  json.array! @system_requirements, :name, :operational_system, :storage, :processor, :memory, :video_board
end