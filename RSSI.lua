-- CONFIG PARAMS --
-- Copyright (C) 2025 BestariwebTV
-- https://www.youtube.com/@BestariwebTV


local barujalan = 0;
local lastRunTS = 0;
local INTERVAL = 80;

local RSS1_ID = -1;
local RSS2_ID = -1;


local RSS1 = 0;
local RSS2 = 0;
local saycount = 0;
local VFile1 = "";
local VFile11 = "";
local VFile2 = "";

local VFileName = { [10] = "010.wav" , [11] = "011.wav", [12] = "012.wav", [13] = "013.wav",
                    [14] = "014.wav" , [15] = "015.wav", [16] = "016.wav" };
local AngkaFileName = { [0] = "0nol.wav" , [1] = "01.wav", [2] = "02.wav", [3] = "03.wav",
                        [4] = "04.wav" , [5] = "05.wav", [6] = "06.wav", [7] = "07.wav",
                        [8] = "08.wav" , [9] = "09.wav" };
local AntennaFile = {[1] = "0blkg.wav",[2] = "0dpn.wav"};
local SoundFilesPath = "/SCRIPTS/TELEMETRY/SND/";
local MinusFile = SoundFilesPath.."0min.wav";
local dbFile = SoundFilesPath.."0db.wav";
local function getTelemetryId(name)
     local field = getFieldInfo(name)
     if field then
       local fieldId = field['id'];
       if fieldId ~= nil then
         return fieldId;
       else
        return -1;
       end
     else
       return -1
     end
 end

local function sayV(nilaiV,antX)
  local nilaiplus = -1 * nilaiV;
  local digit1 = 0;
  local digit2 = 0;
  VFile2 = "";
  VFile2 = "";
  
  if nilaiplus < 100 and nilaiplus > 19 then
    digit1 = math.floor(nilaiplus/10);
    digit2 = math.floor(nilaiplus-(digit1*10));
    VFile1 = AngkaFileName[digit1];
    if VFile1 ~= nil then
      VFile1 = SoundFilesPath..VFile1;
    end
    VFile2 = AngkaFileName[digit2];
    if VFile2 ~= nil then
      VFile2 = SoundFilesPath..VFile2;
    end
    
    --if VFile1 ~= nil and VFile2 ~= nil then
      playFile(SoundFilesPath..AntennaFile[antX]);
      playFile(MinusFile);
      playFile(VFile1);
      playFile(VFile2);
      playFile(dbFile);
    -- end
  end

  if nilaiplus < 20 and nilaiplus > 10 then
    digit2 = math.floor(nilaiplus-10);
      VFile1 = SoundFilesPath..AngkaFileName[digit2];
      VFile2 = SoundFilesPath.."0belas.wav";
    --if VFile1 ~= nil and VFile2 ~= nil then
      playFile(SoundFilesPath..AntennaFile[antX]);
      playFile(MinusFile);
      playFile(VFile1);
      playFile(VFile2);
      playFile(dbFile);
    --end
  end
end

local function init()
  lastRunTS = 0;
end
local function run()
  lcd.clear();
  lcd.drawScreenTitle("RSS ANTENNA", 1, 1);
  lcd.drawText(3, 10,"Antenna Blk : "..string.format("%.2f",RSS1).." db");
  lcd.drawText(3, 20,"Antenna Dpn : "..string.format("%.2f",RSS2).." db");
  lcd.drawText(10, 45,"(C)BestariwebTV");
end
local function bg()
  if lastRunTS == 0 or lastRunTS + INTERVAL < getTime() then

   
  -- Ambil Nilai Tegangan batre drone
    if RSS1_ID < 0 then
      RSS1_ID = getTelemetryId("1RSS");
    end

    if RSS2_ID < 0 then
      RSS2_ID = getTelemetryId("2RSS");
    end

      RSS1 = getValue(RSS1_ID);
      RSS2 = getValue(RSS2_ID);
      if saycount > 30 or barujalan == 0 then
        barujalan = 1;
        sayV(RSS1,1);
        sayV(RSS2,2);
        saycount = 0;  
      end
      saycount = saycount + 1;
      
    lastRunTS = getTime();
  end
end
return { init=init, run=run, background=bg }
