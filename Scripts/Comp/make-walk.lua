local function TableConcat(t1, t2)
    for i = 1, #t2 do t1[#t1 + 1] = t2[i] end
    return t1
end

local function MakePlaylist(resolve)
    print("Creating new playlist")
    local projectManager = resolve:GetProjectManager()
    local project = projectManager:GetCurrentProject()
    local mediaPool = project:GetMediaPool()
    local rootFolder = mediaPool:GetRootFolder()
    local clips = rootFolder:GetClipList()

	if (project:GetTimelineCount() > 0) then
		return
	end

    mediaPool:CreateTimelineFromClips("Walk", clips)
end

local function ApplyDRXToAllTimelineClips(timeline)
    print("Applying grading to " .. timeline:GetName())

    local clips = {}

    local trackCount = timeline:GetTrackCount("video")
    for index = 1, trackCount, 1 do
        TableConcat(clips, timeline:GetItemsInTrack("video", index))
    end

    local path = "G:/My Drive/Photos/Assets/ColorTables/HDR24_1.1.1.drx"
    return timeline:ApplyGradeFromDRX(path, tonumber(0), clips)
end

local function ApplyDRXToAllTimelines(resolve)
    local projectManager = resolve:GetProjectManager()
    local project = projectManager:GetCurrentProject()
    if not project then return false end

    local timelineCount = project:GetTimelineCount()

    for index = 1, timelineCount, 1 do
        local timeline = project:GetTimelineByIndex(index)
        project:SetCurrentTimeline(timeline)
        if not ApplyDRXToAllTimelineClips(timeline) then return false end
    end
    return true
end

resolve = Resolve()

MakePlaylist(resolve)

ApplyDRXToAllTimelines(resolve)

resolve:OpenPage("edit")

