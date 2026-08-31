import { createContext, useContext, useEffect, useState, type ReactNode } from 'react';

interface Settings {
  reverseJudge: boolean;
  skipScanPreview: boolean;
}

const DEFAULT_SETTINGS: Settings = {
  reverseJudge: false,
  skipScanPreview: false,
};

const STORAGE_KEY = 'eng-vocab-app.settings';

interface SettingsContextValue extends Settings {
  setReverseJudge: (value: boolean) => void;
  setSkipScanPreview: (value: boolean) => void;
}

const SettingsContext = createContext<SettingsContextValue | null>(null);

function loadSettings(): Settings {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return DEFAULT_SETTINGS;
    return { ...DEFAULT_SETTINGS, ...JSON.parse(raw) };
  } catch {
    return DEFAULT_SETTINGS;
  }
}

export function SettingsProvider({ children }: { children: ReactNode }) {
  const [settings, setSettings] = useState<Settings>(loadSettings);

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(settings));
  }, [settings]);

  const value: SettingsContextValue = {
    ...settings,
    setReverseJudge: (value) => setSettings((s) => ({ ...s, reverseJudge: value })),
    setSkipScanPreview: (value) => setSettings((s) => ({ ...s, skipScanPreview: value })),
  };

  return <SettingsContext.Provider value={value}>{children}</SettingsContext.Provider>;
}

export function useSettings(): SettingsContextValue {
  const ctx = useContext(SettingsContext);
  if (!ctx) throw new Error('useSettings must be used within SettingsProvider');
  return ctx;
}
