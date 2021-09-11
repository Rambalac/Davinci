resolve = Resolve()
projectManager = resolve:GetProjectManager()
project = projectManager:GetCurrentProject()
mediaPool = project:GetMediaPool()
rootFolder = mediaPool:GetRootFolder()
clips = rootFolder:GetClips()

for clipIndex in pairs(clips) do
    clip = clips[clipIndex]
    videoCodec = clip:GetClipProperty()["Video Codec"]
    if videoCodec ~= "" then
      if mediaPool:AppendToTimeline({ clip }) then
        print("added clip \"" .. clip:GetName() .. "\" to current timeline.")
      end
    end
end