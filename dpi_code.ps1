Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class DisplaySettings
{
    [DllImport("user32.dll")]
    public static extern int ChangeDisplaySettingsEx(string lpszDeviceName, IntPtr lpDevMode, IntPtr hwnd, uint dwflags, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern bool EnumDisplaySettings(string lpszDeviceName, int iModeNum, IntPtr lpDevMode);

    [StructLayout(LayoutKind.Sequential)]
    public struct DEVMODE
    {
        private const int CCHDEVICENAME = 0x20;
        private const int DM_DISPLAYFREQUENCY = 0x400000;
        private const int DM_DISPLAYFLAGS = 0x200000;
        private const int DM_POSITION = 0x20;
        private const int DM_PELSWIDTH = 0x80000;
        private const int DM_PELSHEIGHT = 0x100000;
        private const int DM_SIZE = 0x40;
        private const int DM_DISPLAYORIENTATION = 0x80;

        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = CCHDEVICENAME)]
        public string dmDeviceName;
        public short dmSpecVersion;
        public short dmDriverVersion;
        public short dmSize;
        public short dmDriverExtra;
        public int dmFields;

        public short dmOrientation;
        public short dmPaperSize;
        public short dmPaperLength;
        public short dmPaperWidth;
        public short dmScale;
        public short dmCopies;
        public short dmDefaultSource;
        public short dmPrintQuality;
        public short dmColor;
        public short dmDuplex;
        public short dmYResolution;
        public short dmTTOption;
        public short dmCollate;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = CCHDEVICENAME)]
        public string dmFormName;
        public short dmLogPixels;
        public int dmBitsPerPel;
        public int dmPelsWidth;
        public int dmPelsHeight;
        public int dmDisplayFlags;
        public int dmDisplayFrequency;
        public int dmICMMethod;
        public int dmICMIntent;
        public int dmMediaType;
        public int dmDitherType;
        public int dmReserved1;
        public int dmReserved2;
        public int dmPanningWidth;
        public int dmPanningHeight;
    }

    public static void SetDPI(int dpi)
    {
        DEVMODE dm = new DEVMODE();
        dm.dmDeviceName = new String(new char[32]);
        dm.dmSize = (short)Marshal.SizeOf(dm);

        if (EnumDisplaySettings(null, -1, ref dm) == false)
            return;

        dm.dmFields = dm.dmFields | 0x00000800; // DM_LOGPIXELS
        dm.dmLogPixels = (short)dpi;

        ChangeDisplaySettingsEx(null, IntPtr.Zero, IntPtr.Zero, 0x02 | 0x04, IntPtr.Zero); // CDS_UPDATEREGISTRY | CDS_GLOBAL

        if (ChangeDisplaySettingsEx(null, ref dm, IntPtr.Zero, 0x02 | 0x04 | 0x40, IntPtr.Zero) != 0)
            ChangeDisplaySettingsEx(null, IntPtr.Zero, IntPtr.Zero, 0x02 | 0x04, IntPtr.Zero); // CDS_UPDATEREGISTRY | CDS_GLOBAL
    }
}
"@

[DisplaySettings]::SetDPI(150)
