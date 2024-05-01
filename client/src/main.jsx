import react from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter as Router } from 'react-router-dom';
import {ChainId, ThirdwebProvider } from '@thirdweb-dev/react';

import {StateContextProvider} from "./context";
import App from './App';
import './index.css';

const root = ReactDOM.createRoot(document.getElementById('root'));

root.render(
    <ThirdwebProvider activeChain="sepolia" clientId="85a1cb3dc4d48eb7ce5b4fea0045fdb3">
        <Router>
            <StateContextProvider>
                <App />
            </StateContextProvider>
        </Router>
    </ThirdwebProvider>
)