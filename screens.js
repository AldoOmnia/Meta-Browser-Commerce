// Meta Browser Commerce — Screen templates for grant mockup

const SCREENS = {
  pairing: `
    <div class="screen pairing-screen active">
      <div class="pairing-content">
        <div class="glasses-illustration"></div>
        <div class="pairing-status">
          <div class="pulse-dot"></div>
          <h1>Connect Meta AI Glasses</h1>
          <p>Put your glasses in pairing mode and tap below to connect via Meta DAT</p>
          <button class="btn-primary">Pair Glasses</button>
          <button class="btn-primary btn-secondary">Skip — Use Phone Only</button>
        </div>
      </div>
    </div>
  `,

  home: `
    <div class="screen home-screen active">
      <div class="home-header">
        <h1>Meta Browser Commerce</h1>
        <p>Hands-free search and buy</p>
        <div class="connection-badge">
          <span class="dot"></span> Connected to Glasses
        </div>
      </div>

      <div class="voice-prompt">
        <div class="voice-prompt-label">Say on your glasses:</div>
        <div class="voice-prompt-examples">
          <div class="voice-example">
            <span class="icon">🔍</span>
            "Find running shoes under $80"
          </div>
          <div class="voice-example">
            <span class="icon">⚖️</span>
            "Compare iPhone and Pixel"
          </div>
          <div class="voice-example">
            <span class="icon">🛒</span>
            "Add Nike Air Max to cart"
          </div>
        </div>
      </div>

      <div class="voice-prompt">
        <div class="voice-prompt-label">Recent activity</div>
        <div class="voice-prompt-examples">
          <div class="voice-example">
            <span class="icon">📦</span>
            Running shoes — 12 results
          </div>
          <div class="voice-example">
            <span class="icon">📱</span>
            iPhone vs Pixel — compared
          </div>
        </div>
      </div>
    </div>
  `,

  search: `
    <div class="screen search-screen active">
      <div class="results-header">
        <div class="results-query">Voice: "Find running shoes under $80"</div>
        <h2>Results from Nike, Amazon, Target</h2>
      </div>

      <div class="result-card">
        <div class="thumb"></div>
        <div class="info">
          <div class="title">Nike Revolution 7</div>
          <div class="meta">Men's running shoes, multiple colors</div>
          <div class="price">$69.97</div>
          <div class="source">Nike.com</div>
        </div>
      </div>

      <div class="result-card">
        <div class="thumb"></div>
        <div class="info">
          <div class="title">Nike Air Zoom Pegasus</div>
          <div class="meta">Lightweight, responsive cushioning</div>
          <div class="price">$79.99</div>
          <div class="source">Amazon</div>
        </div>
      </div>

      <div class="result-card">
        <div class="thumb"></div>
        <div class="info">
          <div class="title">Adidas Runfalcon 3</div>
          <div class="meta">Comfortable everyday runner</div>
          <div class="price">$64.99</div>
          <div class="source">Target</div>
        </div>
      </div>

      <p style="font-size: 13px; color: var(--text-secondary); text-align: center; padding: 12px 0;">
        Results spoken to your glasses • Tap for details or say "compare" / "add to cart"
      </p>
    </div>
  `,

  compare: `
    <div class="screen compare-screen active">
      <div class="compare-header">
        <div class="results-query">Voice: "Compare iPhone and Pixel"</div>
        <h2>Side-by-side comparison</h2>
      </div>

      <div class="compare-grid">
        <div class="compare-card">
          <div class="thumb"></div>
          <div class="title">iPhone 16</div>
          <div class="specs">6.1" • A18 • 128GB • $799</div>
          <div class="price">$799</div>
        </div>
        <div class="compare-card">
          <div class="thumb"></div>
          <div class="title">Google Pixel 9</div>
          <div class="specs">6.3" • Tensor G4 • 128GB • $799</div>
          <div class="price">$799</div>
        </div>
      </div>

      <p style="font-size: 13px; color: var(--text-secondary); margin-bottom: 16px;">
        Comparison spoken to your glasses. Say "add iPhone to cart" or "add Pixel to cart."
      </p>

      <button class="btn-primary">Add iPhone to Cart</button>
      <button class="btn-primary btn-secondary" style="margin-top: 8px;">Add Pixel to Cart</button>
    </div>
  `,

  cart: `
    <div class="screen cart-screen active">
      <div class="cart-header">
        <h2>Your cart</h2>
        <p style="font-size: 14px; color: var(--text-secondary); margin-top: 4px;">Added by voice on glasses</p>
      </div>

      <div class="cart-item">
        <div class="thumb"></div>
        <div class="info">
          <div class="title">Nike Revolution 7</div>
          <div class="meta">Size 10 • $69.97</div>
        </div>
      </div>

      <div class="cart-item">
        <div class="thumb"></div>
        <div class="info">
          <div class="title">iPhone 16</div>
          <div class="meta">128GB • $799</div>
        </div>
      </div>

      <div class="cart-summary">
        <div class="cart-total">
          <span>Total</span>
          <span>$868.97</span>
        </div>
        <button class="btn-primary">Checkout</button>
      </div>
    </div>
  `,

  flow: `
    <div class="screen flow-screen active">
      <h2>Voice flow diagram</h2>
      <p style="font-size: 14px; color: var(--text-secondary); text-align: center; margin-bottom: 20px;">
        Technical flow for grant application
      </p>

      <div class="flow-diagram">
        <div class="flow-step">
          <span class="num">1</span>
          <div>
            <div class="label">User speaks on Meta AI Glasses</div>
            <div class="tech">"Find running shoes under $80"</div>
          </div>
        </div>
        <div class="flow-arrow">↓ Meta DAT (voice capture)</div>
        <div class="flow-step">
          <span class="num">2</span>
          <div>
            <div class="label">Mobile app receives intent</div>
            <div class="tech">Intent parsing → MCP client</div>
          </div>
        </div>
        <div class="flow-arrow">↓</div>
        <div class="flow-step">
          <span class="num">3</span>
          <div>
            <div class="label">Browser server executes search</div>
            <div class="tech">run_browser_task / execute_website_action</div>
          </div>
        </div>
        <div class="flow-arrow">↓ browser-use on retailer URLs</div>
        <div class="flow-step">
          <span class="num">4</span>
          <div>
            <div class="label">Structured results returned</div>
            <div class="tech">Nike, Amazon, Target, etc.</div>
          </div>
        </div>
        <div class="flow-arrow">↓</div>
        <div class="flow-step">
          <span class="num">5</span>
          <div>
            <div class="label">TTS → Meta DAT → Glasses</div>
            <div class="tech">User hears results and prices</div>
          </div>
        </div>
      </div>
    </div>
  `
};
