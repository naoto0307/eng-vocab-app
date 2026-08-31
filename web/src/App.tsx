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
          <Route path="/study/scope" element={<StudyScopeScreen />} />
          <Route path="/study" element={<StudyScreen />} />
        </Routes>
      </BrowserRouter>
    </SettingsProvider>
  );
}
