Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class DisplaySettings
{
    [DllImport("user32.dll")]
    public static extern int EnumDisplaySettings(string deviceName, int modeNum, ref DEVMODE devMode);

    [DllImport("user32.dll")]
    public static extern int ChangeDisplaySettings(ref DEVMODE devMode, int flags);

    [StructLayout(LayoutKind.Sequential)]
    public struct DEVMODE
    {
        private const int DMDO_DEFAULT = 0;
        private const int DMDO_90 = 1;
        private const int DMDO_180 = 2;
        private const int DMDO_270 = 3;

        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
        public string dmDeviceName;
        public short dmSpecVersion;
        public short dmDriverVersion;
        public short dmSize;
        public short dmDriverExtra;
        public int dmFields;
        public int dmPositionX;
        public int dmPositionY;
        public int dmDisplayOrientation;
        public int dmDisplayFixedOutput;
    }

    public static void SetScreenRotation(int rotation)
    {
        DEVMODE dm = new DEVMODE();
        dm.dmDeviceName = new String(new char[32]);
        dm.dmSize = (short)Marshal.SizeOf(dm);

        EnumDisplaySettings(null, -1, ref dm);
        dm.dmDisplayOrientation = rotation;

        ChangeDisplaySettings(ref dm, 0x01);
    }
}
"@

[DisplaySettings]::SetScreenRotation(1)
