import { Suspense, lazy } from 'react';
import { BrowserRouter, Route, Routes } from 'react-router-dom';
import { SettingsProvider } from './store/settingsStore';
import { HubLayout } from './components/HubLayout';
import { HomeScreen } from './screens/HomeScreen';
import { WordListScreen } from './screens/WordListScreen';
import { WordDetailScreen } from './screens/WordDetailScreen';
import { AddMethodScreen } from './screens/AddMethodScreen';
import { AddManualScreen } from './screens/AddManualScreen';
import { StudyScopeScreen } from './screens/StudyScopeScreen';
import { StudyScreen } from './screens/StudyScreen';
import { RecordScreen } from './screens/RecordScreen';
import { SettingsScreen } from './screens/SettingsScreen';

// マーカースキャンはOCR(Tesseract.js)・PDFレンダラ(pdfjs-dist)を含み重いため、
// 実際にスキャン機能を使う人だけがダウンロードすればよいよう遅延読み込みにする
const AddScanScreen = lazy(() => import('./screens/AddScanScreen').then((m) => ({ default: m.AddScanScreen })));
const ScanPreviewScreen = lazy(() =>
  import('./screens/ScanPreviewScreen').then((m) => ({ default: m.ScanPreviewScreen })),
);

function LazyFallback() {
  return (
    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', height: '100vh' }}>
      <div className="spinner" />
    </div>
  );
}

export default function App() {
  return (
    <SettingsProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<HubLayout><HomeScreen /></HubLayout>} />
          <Route path="/words" element={<HubLayout><WordListScreen /></HubLayout>} />
          <Route path="/record" element={<HubLayout><RecordScreen /></HubLayout>} />
          <Route path="/settings" element={<HubLayout><SettingsScreen /></HubLayout>} />

          <Route path="/words/:id" element={<WordDetailScreen />} />
          <Route path="/add" element={<AddMethodScreen />} />
          <Route path="/add/manual" element={<AddManualScreen />} />
          <Route
            path="/add/scan"
            element={
              <Suspense fallback={<LazyFallback />}>
                <AddScanScreen />
              </Suspense>
            }
          />
          <Route
            path="/add/scan/preview"
            element={
              <Suspense fallback={<LazyFallback />}>
                <ScanPreviewScreen />
              </Suspense>
            }
          />
          <Route path="/study/scope" element={<StudyScopeScreen />} />
          <Route path="/study" element={<StudyScreen />} />
        </Routes>
      </BrowserRouter>
    </SettingsProvider>
  );
}
