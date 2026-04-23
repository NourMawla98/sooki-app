/* global React */
// Cart screen — Electric Aurora
// Renders both dark + light modes. The `theme` prop switches all tokens.

const { useState, useEffect, useRef } = React;

// ───────────────────────────────────────────────────────────────
// TOKENS (mirrors lib/themes/app_colors.dart — Electric Aurora)
// ───────────────────────────────────────────────────────────────
const TOKENS = {
  dark: {
    // bg gradient stops
    bg0: '#0a0a18',
    bg1: '#0e0820',
    bg2: '#12081a',
    // header / nav chrome
    chrome: 'rgba(10,10,24,0.88)',
    chromeBorder: 'rgba(255,255,255,0.04)',
    // glass surfaces
    glassFill: 'rgba(255,255,255,0.03)',
    glassFillHover: 'rgba(255,255,255,0.05)',
    glassBorder: 'rgba(255,255,255,0.08)',
    glassBorderStrong: 'rgba(255,255,255,0.12)',
    // input chip fills
    chipFill: 'rgba(255,255,255,0.04)',
    chipBorder: 'rgba(255,255,255,0.10)',
    // text
    text: '#FFFFFF',
    textMute: 'rgba(255,255,255,0.55)',
    textMute2: 'rgba(255,255,255,0.35)',
    textMute3: 'rgba(255,255,255,0.22)',
    textMute4: 'rgba(255,255,255,0.12)',
    // thumb placeholder base
    thumb: '#1b1530',
    thumbStripe: 'rgba(255,255,255,0.04)',
    // divider
    divider: 'rgba(255,255,255,0.06)',
    // floating decor opacity
    decorOpacity: 0.14,
    // shadow behind summary sheet
    sheetShadow: '0 -18px 40px rgba(0,0,0,0.55)',
    sheetTop: 'rgba(255,255,255,0.06)',
  },
  light: {
    bg0: '#f8f8fc',
    bg1: '#f2f0fa',
    bg2: '#f5f0f8',
    chrome: 'rgba(255,255,255,0.92)',
    chromeBorder: '#ececf4',
    glassFill: 'rgba(255,255,255,0.75)',
    glassFillHover: 'rgba(255,255,255,0.9)',
    glassBorder: 'rgba(124,58,237,0.16)',
    glassBorderStrong: 'rgba(124,58,237,0.28)',
    chipFill: '#ffffff',
    chipBorder: '#e4e0f0',
    text: '#1a1a2e',
    textMute: 'rgba(26,26,46,0.65)',
    textMute2: 'rgba(26,26,46,0.45)',
    textMute3: 'rgba(26,26,46,0.30)',
    textMute4: 'rgba(26,26,46,0.15)',
    thumb: '#ecebf5',
    thumbStripe: 'rgba(124,58,237,0.06)',
    divider: 'rgba(26,26,46,0.08)',
    decorOpacity: 0.18,
    sheetShadow: '0 -12px 32px rgba(26,26,46,0.10)',
    sheetTop: 'rgba(124,58,237,0.12)',
  },
};

// Aurora accents are shared across themes.
const AURORA = {
  blue: '#0096FF',
  violet: '#7C3AED',
  pink: '#FF00C8',
  blueLight: '#2AB5FF',
  logoCoral: '#FF5E8A',
  logoTeal: '#00D4C5',
};

const AURORA_GRAD = `linear-gradient(135deg, ${AURORA.pink} 0%, ${AURORA.violet} 50%, ${AURORA.blue} 100%)`;
const AURORA_GRAD_HORIZ = `linear-gradient(90deg, ${AURORA.blue}, ${AURORA.violet}, ${AURORA.pink}, ${AURORA.blue})`;

// ───────────────────────────────────────────────────────────────
// MOCK DATA — realistic cart
// ───────────────────────────────────────────────────────────────
const DEFAULT_ITEMS = [
  {
    id: 1,
    name: 'Nimbus Oversized Puffer Jacket',
    color: 'Midnight',
    colorDot: '#1b1b2e',
    size: 'M',
    unit: 189.0,
    original: 249.0,
    qty: 1,
    stock: 6,
    thumbHue: 278,
  },
  {
    id: 2,
    name: 'Aurora Glow Sneakers — High Top',
    color: 'Hot Pink',
    colorDot: AURORA.pink,
    size: '42',
    unit: 129.9,
    original: null,
    qty: 2,
    stock: 12,
    thumbHue: 322,
  },
  {
    id: 3,
    name: 'Matte Ceramic Water Bottle 750ml',
    color: 'Electric Blue',
    colorDot: AURORA.blue,
    size: null,
    unit: 24.5,
    original: null,
    qty: 1,
    stock: 20,
    thumbHue: 205,
  },
];

// ───────────────────────────────────────────────────────────────
// Reusable bits
// ───────────────────────────────────────────────────────────────
function Fa({ name, size = 14, color, style }) {
  return (
    <i
      className={`fa-solid fa-${name}`}
      style={{ fontSize: size, color, lineHeight: 1, ...style }}
    />
  );
}

// Thumbnail placeholder — striped monochrome surface in the item's "hue",
// with a soft aurora tint blob so it reads as imagery not just a block.
function Thumb({ hue, t }) {
  const tone = t === TOKENS.dark ? 0.55 : 0.28;
  const stripe = t.thumbStripe;
  return (
    <div
      style={{
        width: 58,
        height: 58,
        borderRadius: 10,
        overflow: 'hidden',
        position: 'relative',
        background: `linear-gradient(135deg, hsl(${hue} 50% ${t === TOKENS.dark ? 14 : 82}%), hsl(${
          hue + 30
        } 50% ${t === TOKENS.dark ? 20 : 88}%))`,
        border: `1px solid ${t.glassBorder}`,
        flexShrink: 0,
      }}
    >
      {/* diagonal stripes */}
      <div
        style={{
          position: 'absolute',
          inset: 0,
          backgroundImage: `repeating-linear-gradient(135deg, ${stripe} 0 6px, transparent 6px 12px)`,
        }}
      />
      {/* aurora glow blob */}
      <div
        style={{
          position: 'absolute',
          width: 48,
          height: 48,
          left: -10,
          bottom: -10,
          borderRadius: '50%',
          background: `radial-gradient(circle, ${AURORA.pink}, transparent 70%)`,
          opacity: tone * 0.6,
          filter: 'blur(4px)',
        }}
      />
      <div
        style={{
          position: 'absolute',
          width: 44,
          height: 44,
          right: -8,
          top: -8,
          borderRadius: '50%',
          background: `radial-gradient(circle, ${AURORA.blue}, transparent 70%)`,
          opacity: tone * 0.6,
          filter: 'blur(4px)',
        }}
      />
    </div>
  );
}

// Aurora gradient stepper (matches PriceQuantityRow approach).
function QtyStepper({ qty, onMinus, onPlus, t }) {
  const isMinusDisabled = qty <= 1;
  const btn = (label, onClick, color, disabled) => (
    <button
      onClick={onClick}
      disabled={disabled}
      style={{
        width: 26,
        height: 26,
        borderRadius: 8,
        border: 'none',
        background: `${color}1F`, // 12% alpha
        color,
        fontSize: 10,
        cursor: disabled ? 'not-allowed' : 'pointer',
        opacity: disabled ? 0.35 : 1,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        padding: 0,
      }}
    >
      <Fa name={label} size={9} color={color} />
    </button>
  );
  return (
    <div
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        padding: 3,
        gap: 2,
        borderRadius: 11,
        background: t.chipFill,
        border: `1px solid ${t.chipBorder}`,
      }}
    >
      {btn('minus', onMinus, AURORA.pink, isMinusDisabled)}
      <div
        style={{
          width: 26,
          textAlign: 'center',
          fontSize: 13,
          fontWeight: 800,
          color: t.text,
        }}
      >
        {qty}
      </div>
      {btn('plus', onPlus, AURORA.blue, false)}
    </div>
  );
}

// Gradient text (for price totals).
function GradientText({ children, size = 14, weight = 800, style }) {
  return (
    <span
      style={{
        background: `linear-gradient(90deg, ${AURORA.pink}, ${AURORA.blue})`,
        WebkitBackgroundClip: 'text',
        WebkitTextFillColor: 'transparent',
        backgroundClip: 'text',
        fontWeight: weight,
        fontSize: size,
        letterSpacing: -0.2,
        ...style,
      }}
    >
      {children}
    </span>
  );
}

// ───────────────────────────────────────────────────────────────
// Chrome: header, floating bg decor, bottom nav + FAB
// ───────────────────────────────────────────────────────────────
function FloatingDecor({ t }) {
  // Six drifting shopping elements — price pills, discount badge, hearts.
  // Positioned absolutely, animate via CSS keyframes.
  const decor = [
    { kind: 'price', text: '$24.99', accent: AURORA.blue, top: 56, left: 14, dur: '6s', delay: '0s' },
    { kind: 'price', text: '$89.00', accent: AURORA.violet, top: 180, right: 18, dur: '7s', delay: '1.2s' },
    { kind: 'disc', text: '-50%', accent: AURORA.pink, top: 120, right: 40, dur: '5.5s', delay: '0.4s' },
    { kind: 'heart', top: 240, left: 22, dur: '6.2s', delay: '1.5s' },
    { kind: 'bag', top: 420, right: 26, dur: '6.8s', delay: '0.8s' },
    { kind: 'star', top: 360, left: 28, dur: '5.4s', delay: '2s' },
  ];
  return (
    <div
      style={{
        position: 'absolute',
        inset: 0,
        pointerEvents: 'none',
        overflow: 'hidden',
        opacity: t.decorOpacity,
      }}
    >
      {/* Two big radial blobs (blue top-right, pink bottom-left) */}
      <div
        style={{
          position: 'absolute',
          width: 260,
          height: 260,
          top: -80,
          right: -80,
          borderRadius: '50%',
          background: `radial-gradient(circle, ${AURORA.blue}, transparent 65%)`,
          filter: 'blur(12px)',
          animation: 'cartGentlePulse 6s ease-in-out infinite',
        }}
      />
      <div
        style={{
          position: 'absolute',
          width: 280,
          height: 280,
          bottom: -100,
          left: -100,
          borderRadius: '50%',
          background: `radial-gradient(circle, ${AURORA.pink}, transparent 65%)`,
          filter: 'blur(14px)',
          animation: 'cartGentlePulse 7s ease-in-out infinite 1s',
        }}
      />
      {decor.map((d, i) => (
        <div
          key={i}
          style={{
            position: 'absolute',
            top: d.top,
            left: d.left,
            right: d.right,
            animation: `cartFloat ${d.dur} ease-in-out infinite ${d.delay}`,
          }}
        >
          {d.kind === 'price' && (
            <div
              style={{
                padding: '5px 10px',
                borderRadius: 9,
                background: `${d.accent}1A`,
                border: `1px solid ${d.accent}4D`,
                boxShadow: `0 0 16px ${d.accent}40`,
                fontFamily: 'ui-monospace, Menlo, monospace',
                fontSize: 12,
                fontWeight: 700,
                color: t.text,
                whiteSpace: 'nowrap',
              }}
            >
              {d.text}
            </div>
          )}
          {d.kind === 'disc' && (
            <div
              style={{
                padding: '5px 10px',
                borderRadius: 20,
                background: `${d.accent}1A`,
                border: `1px solid ${d.accent}66`,
                boxShadow: `0 0 16px ${d.accent}50`,
                fontSize: 12,
                fontWeight: 900,
                color: t.text,
                letterSpacing: 0.5,
              }}
            >
              {d.text}
            </div>
          )}
          {d.kind === 'heart' && <Fa name="heart" size={18} color={AURORA.pink} />}
          {d.kind === 'bag' && <Fa name="bag-shopping" size={18} color={AURORA.violet} />}
          {d.kind === 'star' && <Fa name="star" size={16} color={AURORA.blue} />}
        </div>
      ))}
    </div>
  );
}

function AppHeader({ t, itemCount }) {
  return (
    <div
      style={{
        position: 'relative',
        zIndex: 10,
        background: t.chrome,
        backdropFilter: 'blur(20px)',
        WebkitBackdropFilter: 'blur(20px)',
        borderBottom: `1px solid ${t.chromeBorder}`,
      }}
    >
      <div style={{ padding: '56px 16px 12px' }}>
        {/* Row 1 — back, title, icons */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 12 }}>
          <button
            style={{
              width: 34,
              height: 34,
              borderRadius: 10,
              background: t.chipFill,
              border: `1px solid ${t.chipBorder}`,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              cursor: 'pointer',
              padding: 0,
            }}
          >
            <Fa name="arrow-left" size={14} color={t.text} />
          </button>
          <div style={{ flex: 1 }}>
            <div
              style={{
                fontSize: 10,
                fontWeight: 800,
                letterSpacing: 2,
                color: AURORA.pink,
                textTransform: 'uppercase',
                marginBottom: 2,
              }}
            >
              Your Bag
            </div>
            <div style={{ fontSize: 18, fontWeight: 900, color: t.text, letterSpacing: -0.3 }}>
              Cart
              <span style={{ color: t.textMute2, fontWeight: 600, marginLeft: 6, fontSize: 14 }}>
                · {itemCount} {itemCount === 1 ? 'item' : 'items'}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function BottomNav({ t }) {
  const tabs = [
    { icon: 'house', label: 'Browse', active: false },
    { icon: 'bolt', label: 'Deals', active: false },
    { icon: null, label: null }, // gap for FAB
    { icon: 'gift', label: 'Loyalty', active: false },
    { icon: 'cart-shopping', label: 'Cart', active: true },
  ];
  return (
    <div
      style={{
        position: 'relative',
        background: t.chrome,
        backdropFilter: 'blur(20px)',
        WebkitBackdropFilter: 'blur(20px)',
        boxShadow: t.sheetShadow,
      }}
    >
      {/* Aurora animated gradient line */}
      <div
        style={{
          height: 2,
          background: AURORA_GRAD_HORIZ,
          backgroundSize: '200% 100%',
          animation: 'auroraBarShift 3s linear infinite',
        }}
      />
      <div
        style={{
          display: 'flex',
          height: 76,
          alignItems: 'center',
          padding: '0 4px',
          paddingBottom: 22,
        }}
      >
        {tabs.map((tab, i) => {
          if (!tab.icon) return <div key={i} style={{ flex: 1 }} />;
          const col = tab.active ? AURORA.blue : t.textMute2;
          return (
            <div
              key={i}
              style={{
                flex: 1,
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                gap: 4,
              }}
            >
              <Fa
                name={tab.icon}
                size={18}
                color={col}
                style={tab.active ? { filter: `drop-shadow(0 0 8px ${AURORA.blue}80)` } : {}}
              />
              <div
                style={{
                  fontSize: 9,
                  fontWeight: tab.active ? 800 : 500,
                  color: col,
                  letterSpacing: 0.2,
                  textShadow: tab.active ? `0 0 8px ${AURORA.blue}90` : 'none',
                }}
              >
                {tab.label}
              </div>
            </div>
          );
        })}
      </div>
      {/* Floating FAB over the central gap */}
      <div
        style={{
          position: 'absolute',
          left: '50%',
          transform: 'translateX(-50%)',
          top: -24,
          width: 56,
          height: 56,
          borderRadius: '50%',
          background: AURORA_GRAD,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          boxShadow: `0 0 28px ${AURORA.violet}66, 0 8px 16px rgba(0,0,0,0.25)`,
          animation: 'fabPulse 2s ease-in-out infinite',
        }}
      >
        <Fa name="bag-shopping" size={22} color="#fff" />
      </div>
    </div>
  );
}

// ───────────────────────────────────────────────────────────────
// Cart list item card
// ───────────────────────────────────────────────────────────────
function CartItemCard({ item, t, onQty, onRemove, onFav }) {
  const lineTotal = item.unit * item.qty;
  const pctOff = item.original ? Math.round((1 - item.unit / item.original) * 100) : 0;

  return (
    <div
      style={{
        position: 'relative',
        background: t.glassFill,
        border: `1px solid ${t.glassBorder}`,
        borderRadius: 12,
        padding: 10,
        marginBottom: 8,
        backdropFilter: 'blur(20px)',
        WebkitBackdropFilter: 'blur(20px)',
        display: 'flex',
        alignItems: 'center',
        gap: 10,
      }}
    >
      {/* 44px thumb */}
      <div style={{ flexShrink: 0 }}>
        <div
          style={{
            width: 48,
            height: 48,
            borderRadius: 8,
            overflow: 'hidden',
            position: 'relative',
            background: `linear-gradient(135deg, hsl(${item.thumbHue} 50% ${
              t === TOKENS.dark ? 14 : 82
            }%), hsl(${item.thumbHue + 30} 50% ${t === TOKENS.dark ? 20 : 88}%))`,
            border: `1px solid ${t.glassBorder}`,
          }}
        >
          <div
            style={{
              position: 'absolute',
              inset: 0,
              background: `repeating-linear-gradient(135deg, ${t.thumbStripe} 0 2px, transparent 2px 10px)`,
            }}
          />
          <div
            style={{
              position: 'absolute',
              top: -14,
              right: -14,
              width: 40,
              height: 40,
              borderRadius: '50%',
              background: `radial-gradient(circle, hsl(${item.thumbHue + 20} 80% 60% / 0.55), transparent 70%)`,
              filter: 'blur(6px)',
            }}
          />
        </div>
      </div>

      {/* Name + meta stack */}
      <div style={{ flex: 1, minWidth: 0 }}>
        <div
          style={{
            fontSize: 13,
            fontWeight: 700,
            color: t.text,
            lineHeight: 1.2,
            letterSpacing: -0.1,
            whiteSpace: 'nowrap',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            paddingRight: 20,
          }}
        >
          {item.name}
        </div>
        <div
          style={{
            display: 'flex',
            gap: 6,
            marginTop: 4,
            fontSize: 10,
            color: t.textMute,
            alignItems: 'center',
            flexWrap: 'wrap',
          }}
        >
          <span
            style={{
              width: 7,
              height: 7,
              borderRadius: '50%',
              background: item.colorDot,
              display: 'inline-block',
              boxShadow: `inset 0 0 0 1px ${t.chipBorder}`,
            }}
          />
          <span style={{ fontWeight: 600 }}>{item.color}</span>
          {item.size && (
            <>
              <span style={{ color: t.textMute3 }}>·</span>
              <span style={{ fontWeight: 600 }}>Size {item.size}</span>
            </>
          )}
          {item.stock <= 6 && (
            <>
              <span style={{ color: t.textMute3 }}>·</span>
              <span style={{ color: AURORA.pink, fontWeight: 800, letterSpacing: 0.1 }}>
                Only {item.stock} left
              </span>
            </>
          )}
        </div>
      </div>

      {/* Stepper (existing design) */}
      <QtyStepper
        qty={item.qty}
        t={t}
        onMinus={() => onQty(item.qty - 1)}
        onPlus={() => onQty(item.qty + 1)}
      />

      {/* Price column */}
      <div style={{ textAlign: 'right', flexShrink: 0, minWidth: 62 }}>
        <GradientText size={14} weight={900}>
          ${lineTotal.toFixed(2)}
        </GradientText>
        {item.original && (
          <div
            style={{
              fontSize: 9.5,
              color: AURORA.pink,
              fontWeight: 800,
              marginTop: 2,
              letterSpacing: 0.2,
            }}
          >
            −{pctOff}%
          </div>
        )}
      </div>

      {/* Remove — top-right corner */}
      <button
        onClick={onRemove}
        style={{
          position: 'absolute',
          top: 6,
          right: 6,
          width: 20,
          height: 20,
          borderRadius: 6,
          background: 'transparent',
          border: 'none',
          cursor: 'pointer',
          padding: 0,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
        }}
      >
        <Fa name="xmark" size={10} color={t.textMute2} />
      </button>
    </div>
  );
}


// ───────────────────────────────────────────────────────────────
// Free shipping progress strip (promo card variant)
// ───────────────────────────────────────────────────────────────
function ShippingProgress({ subtotal, threshold, t }) {
  const pct = Math.min(1, subtotal / threshold);
  const remaining = Math.max(0, threshold - subtotal);
  const reached = remaining === 0;
  return (
    <div
      style={{
        margin: '4px 0 12px',
        padding: '12px 14px',
        borderRadius: 16,
        background: t.glassFill,
        border: `1px solid ${t.glassBorder}`,
        position: 'relative',
        overflow: 'hidden',
      }}
    >
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 10 }}>
        <div
          style={{
            width: 32,
            height: 32,
            borderRadius: 10,
            background: reached ? AURORA_GRAD : `${AURORA.blue}1F`,
            border: reached ? 'none' : `1px solid ${AURORA.blue}4D`,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            flexShrink: 0,
            boxShadow: reached ? `0 0 20px ${AURORA.violet}66` : 'none',
          }}
        >
          <Fa name="truck-fast" size={14} color={reached ? '#fff' : AURORA.blue} />
        </div>
        <div style={{ flex: 1, minWidth: 0 }}>
          {reached ? (
            <>
              <div style={{ fontSize: 12, fontWeight: 800, color: t.text, letterSpacing: -0.1 }}>
                <GradientText size={12} weight={900}>
                  You unlocked FREE shipping!
                </GradientText>
              </div>
              <div style={{ fontSize: 10.5, color: t.textMute, marginTop: 2 }}>
                Your order qualifies — we got you.
              </div>
            </>
          ) : (
            <>
              <div style={{ fontSize: 12, fontWeight: 700, color: t.text, letterSpacing: -0.1 }}>
                Spend{' '}
                <GradientText size={12} weight={900}>
                  ${remaining.toFixed(2)}
                </GradientText>{' '}
                more for <span style={{ fontWeight: 800 }}>FREE shipping</span>
              </div>
              <div style={{ fontSize: 10.5, color: t.textMute, marginTop: 2 }}>
                So close. Add one more thing.
              </div>
            </>
          )}
        </div>
      </div>
      {/* progress track */}
      <div
        style={{
          height: 6,
          borderRadius: 999,
          background: t.chipFill,
          border: `1px solid ${t.chipBorder}`,
          position: 'relative',
          overflow: 'hidden',
        }}
      >
        <div
          style={{
            width: `${pct * 100}%`,
            height: '100%',
            background: AURORA_GRAD_HORIZ,
            backgroundSize: '200% 100%',
            animation: 'auroraBarShift 3s linear infinite',
            borderRadius: 999,
            boxShadow: `0 0 10px ${AURORA.violet}80`,
            transition: 'width 400ms ease',
          }}
        />
      </div>
    </div>
  );
}

// ───────────────────────────────────────────────────────────────
// Promo / discount code row
// ───────────────────────────────────────────────────────────────
function PromoRow({ t, applied, onToggle }) {
  return (
    <div
      style={{
        padding: '11px 12px',
        borderRadius: 14,
        background: t.glassFill,
        border: `1px solid ${applied ? AURORA.pink + '66' : t.glassBorder}`,
        display: 'flex',
        alignItems: 'center',
        gap: 10,
        marginBottom: 10,
        boxShadow: applied ? `0 0 16px ${AURORA.pink}33` : 'none',
      }}
    >
      <div
        style={{
          width: 28,
          height: 28,
          borderRadius: 8,
          background: `${AURORA.pink}1F`,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          flexShrink: 0,
        }}
      >
        <Fa name="tag" size={12} color={AURORA.pink} />
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        {applied ? (
          <>
            <div style={{ fontSize: 12, fontWeight: 800, color: t.text, letterSpacing: -0.1 }}>
              AURORA20 applied
            </div>
            <div style={{ fontSize: 10.5, color: t.textMute, marginTop: 1 }}>
              20% off entire order
            </div>
          </>
        ) : (
          <>
            <div style={{ fontSize: 12, fontWeight: 700, color: t.text, letterSpacing: -0.1 }}>
              Have a promo code?
            </div>
            <div style={{ fontSize: 10.5, color: t.textMute, marginTop: 1 }}>
              Tap to enter code or pick from offers
            </div>
          </>
        )}
      </div>
      <button
        onClick={onToggle}
        style={{
          padding: '6px 12px',
          borderRadius: 8,
          background: applied ? 'transparent' : `${AURORA.pink}1F`,
          border: applied ? `1px solid ${t.chipBorder}` : `1px solid ${AURORA.pink}66`,
          color: applied ? t.textMute : AURORA.pink,
          fontSize: 11,
          fontWeight: 800,
          letterSpacing: 0.3,
          cursor: 'pointer',
          textTransform: 'uppercase',
        }}
      >
        {applied ? 'Remove' : 'Apply'}
      </button>
    </div>
  );
}

// ───────────────────────────────────────────────────────────────
// Summary sheet + checkout CTA
// ───────────────────────────────────────────────────────────────
function CartSummary({ subtotal, shipping, discount, total, t, onCheckout, itemCount }) {
  const Row = ({ label, value, muted, accent }) => (
    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
      <div
        style={{
          fontSize: 12.5,
          color: muted ? t.textMute : t.text,
          fontWeight: muted ? 500 : 600,
        }}
      >
        {label}
      </div>
      <div
        style={{
          fontSize: 13,
          fontWeight: 700,
          color: accent || t.text,
        }}
      >
        {value}
      </div>
    </div>
  );
  return (
    <div
      style={{
        position: 'relative',
        background: t.chrome,
        backdropFilter: 'blur(22px)',
        WebkitBackdropFilter: 'blur(22px)',
        borderTop: `1px solid ${t.sheetTop}`,
        padding: '14px 16px 14px',
        boxShadow: t.sheetShadow,
      }}
    >
      {/* thin aurora line accent at top */}
      <div
        style={{
          position: 'absolute',
          top: 0,
          left: '25%',
          right: '25%',
          height: 2,
          background: AURORA_GRAD_HORIZ,
          backgroundSize: '200% 100%',
          animation: 'auroraBarShift 3s linear infinite',
          opacity: 0.75,
          filter: 'blur(0.5px)',
        }}
      />
      <div style={{ display: 'flex', flexDirection: 'column', gap: 6, marginBottom: 10 }}>
        <Row label="Subtotal" value={`$${subtotal.toFixed(2)}`} muted />
        <Row
          label="Shipping"
          value={shipping === 0 ? 'FREE' : `$${shipping.toFixed(2)}`}
          muted
          accent={shipping === 0 ? AURORA.blue : undefined}
        />
        {discount > 0 && (
          <Row label="Promo · AURORA20" value={`−$${discount.toFixed(2)}`} muted accent={AURORA.pink} />
        )}
      </div>
      <div
        style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'baseline',
          paddingTop: 10,
          borderTop: `1px dashed ${t.divider}`,
          marginBottom: 12,
        }}
      >
        <div style={{ fontSize: 13, fontWeight: 800, color: t.text, letterSpacing: -0.1 }}>
          Total{' '}
          <span style={{ color: t.textMute2, fontWeight: 600, fontSize: 11 }}>
            · {itemCount} items
          </span>
        </div>
        <GradientText size={22} weight={900} style={{ letterSpacing: -0.5 }}>
          ${total.toFixed(2)}
        </GradientText>
      </div>

      {/* CHECKOUT CTA — aurora gradient pill */}
      <button
        onClick={onCheckout}
        style={{
          width: '100%',
          height: 52,
          borderRadius: 14,
          border: 'none',
          cursor: 'pointer',
          padding: 0,
          position: 'relative',
          overflow: 'hidden',
          background: AURORA_GRAD,
          boxShadow: `0 10px 30px ${AURORA.violet}55, 0 0 24px ${AURORA.pink}33`,
        }}
      >
        {/* shimmer sweep */}
        <div
          style={{
            position: 'absolute',
            top: 0,
            bottom: 0,
            left: 0,
            width: '40%',
            background:
              'linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent)',
            animation: 'cartShimmer 2.6s ease-in-out infinite',
          }}
        />
        <div
          style={{
            position: 'relative',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: 10,
            height: '100%',
            color: '#fff',
            fontWeight: 900,
            fontSize: 13,
            letterSpacing: 2.2,
          }}
        >
          <Fa name="lock" size={11} color="#fff" />
          PROCEED TO CHECKOUT
          <Fa name="arrow-right" size={11} color="#fff" />
        </div>
      </button>
      <div
        style={{
          display: 'flex',
          justifyContent: 'center',
          gap: 14,
          marginTop: 10,
          color: t.textMute2,
          fontSize: 10,
          fontWeight: 600,
          letterSpacing: 0.3,
        }}
      >
        <div style={{ display: 'flex', alignItems: 'center', gap: 5 }}>
          <Fa name="shield-halved" size={10} color={t.textMute2} /> Secure
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 5 }}>
          <Fa name="rotate-left" size={10} color={t.textMute2} /> Easy returns
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 5 }}>
          <Fa name="money-bill-wave" size={10} color={t.textMute2} /> Cash on delivery
        </div>
      </div>
    </div>
  );
}

// ───────────────────────────────────────────────────────────────
// MAIN CART SCREEN — the whole phone content
// ───────────────────────────────────────────────────────────────
function CartScreen({ theme = 'dark', tweaks = {} }) {
  const t = TOKENS[theme];
  const [items, setItems] = useState(DEFAULT_ITEMS);
  const [promoApplied, setPromoApplied] = useState(tweaks.promoApplied ?? true);

  useEffect(() => {
    setPromoApplied(tweaks.promoApplied ?? true);
  }, [tweaks.promoApplied]);

  const updateQty = (id, newQty) => {
    if (newQty < 1) return;
    setItems(items.map((it) => (it.id === id ? { ...it, qty: newQty } : it)));
  };
  const remove = (id) => setItems(items.filter((it) => it.id !== id));

  const subtotal = items.reduce((s, it) => s + it.unit * it.qty, 0);
  const shipping = 5.99;
  const discount = promoApplied ? subtotal * 0.2 : 0;
  const total = Math.max(0, subtotal + shipping - discount);
  const itemCount = items.reduce((s, it) => s + it.qty, 0);

  // Bg gradient matches splashBackground{Dark,Light}
  const bg = `linear-gradient(160deg, ${t.bg0}, ${t.bg1}, ${t.bg2}, ${t.bg0})`;

  return (
    <div
      style={{
        width: '100%',
        height: '100%',
        display: 'flex',
        flexDirection: 'column',
        background: bg,
        color: t.text,
        fontFamily:
          '"DM Sans", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
        position: 'relative',
        overflow: 'hidden',
      }}
    >
      <FloatingDecor t={t} />
      <AppHeader t={t} itemCount={itemCount} />

      {/* SCROLLABLE content */}
      <div
        style={{
          flex: 1,
          overflowY: 'auto',
          overflowX: 'hidden',
          padding: '12px 14px 8px',
          position: 'relative',
          zIndex: 5,
        }}
      >
        {/* Items list */}
        <div>
          {items.map((item) => (
            <CartItemCard
              key={item.id}
              item={item}
              t={t}
              onQty={(newQ) => updateQty(item.id, newQ)}
              onRemove={() => remove(item.id)}
              onFav={() => {}}
            />
          ))}
        </div>

        {/* Promo row */}
        <PromoRow t={t} applied={promoApplied} onToggle={() => setPromoApplied((v) => !v)} />

        {/* Cash on delivery pill — read-only info */}
        <div
          style={{
            padding: '10px 12px',
            borderRadius: 12,
            background: t.glassFill,
            border: `1px solid ${t.glassBorder}`,
            display: 'flex',
            alignItems: 'center',
            gap: 10,
            marginBottom: 10,
          }}
        >
          <div
            style={{
              width: 26,
              height: 26,
              borderRadius: 8,
              background: `${AURORA.blue}1F`,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              flexShrink: 0,
            }}
          >
            <Fa name="money-bill-wave" size={11} color={AURORA.blue} />
          </div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ fontSize: 11.5, fontWeight: 700, color: t.text, letterSpacing: -0.1 }}>
              Cash on delivery
            </div>
            <div style={{ fontSize: 10, color: t.textMute, marginTop: 1 }}>
              Pay the courier when your order arrives
            </div>
          </div>
        </div>

        <div style={{ height: 6 }} />
      </div>

      <CartSummary
        subtotal={subtotal}
        shipping={shipping}
        discount={discount}
        total={total}
        t={t}
        onCheckout={() => {}}
        itemCount={itemCount}
      />

      <BottomNav t={t} />
    </div>
  );
}

Object.assign(window, { CartScreen, TOKENS, AURORA, AURORA_GRAD, AURORA_GRAD_HORIZ });
