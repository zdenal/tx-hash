import React from 'react';

export default function({tx}) {
  return (
    <li className="list-item">
      <span className={`list-item__id--${tx.state}`}>#{tx.id}</span>
      <span className="list-item__subtext">{tx.state}</span>
      <span>{tx.hash}</span>
    </li>
  )
}
