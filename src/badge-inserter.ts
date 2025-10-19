import * as fs from 'fs';
import * as path from 'path';

const BADGE_MARKER_START = '<!-- karen-badge-start -->';
const BADGE_MARKER_END = '<!-- karen-badge-end -->';

export interface BadgeInsertOptions {
  readmePath: string;
  badgePath: string;
  score: number;
}

/**
 * Inserts or updates the Karen badge in the README.md file
 * Uses HTML comment markers to identify where to place the badge
 */
export function insertBadgeIntoReadme(options: BadgeInsertOptions): boolean {
  const { readmePath, badgePath, score } = options;

  // Check if README exists
  if (!fs.existsSync(readmePath)) {
    return false;
  }

  // Read current README content
  let readmeContent = fs.readFileSync(readmePath, 'utf8');

  // Create badge markdown - use relative path from README location
  const badgeMarkdown = `![Karen Score](${badgePath})`;

  // Check if markers exist
  const hasStartMarker = readmeContent.includes(BADGE_MARKER_START);
  const hasEndMarker = readmeContent.includes(BADGE_MARKER_END);

  if (hasStartMarker && hasEndMarker) {
    // Update existing badge between markers
    const pattern = new RegExp(
      `${escapeRegex(BADGE_MARKER_START)}[\\s\\S]*?${escapeRegex(BADGE_MARKER_END)}`,
      'g'
    );
    readmeContent = readmeContent.replace(
      pattern,
      `${BADGE_MARKER_START}\n${badgeMarkdown}\n${BADGE_MARKER_END}`
    );
  } else if (hasStartMarker || hasEndMarker) {
    // Only one marker exists - this is an error state, don't modify
    return false;
  } else {
    // No markers - insert at the top of the file after any initial heading
    const lines = readmeContent.split('\n');
    let insertIndex = 0;

    // Find first non-empty line or first heading
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i].trim();
      if (line.startsWith('#')) {
        insertIndex = i + 1;
        break;
      }
      if (line.length > 0 && insertIndex === 0) {
        insertIndex = i;
        break;
      }
    }

    // Insert badge with markers after the identified position
    const badgeSection = `\n${BADGE_MARKER_START}\n${badgeMarkdown}\n${BADGE_MARKER_END}\n`;
    lines.splice(insertIndex, 0, badgeSection);
    readmeContent = lines.join('\n');
  }

  // Write updated content back to README
  fs.writeFileSync(readmePath, readmeContent, 'utf8');
  return true;
}

/**
 * Escapes special regex characters in a string
 */
function escapeRegex(str: string): string {
  return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

/**
 * Checks if README already has Karen badge markers
 */
export function hasKarenBadgeMarkers(readmePath: string): boolean {
  if (!fs.existsSync(readmePath)) {
    return false;
  }

  const content = fs.readFileSync(readmePath, 'utf8');
  return content.includes(BADGE_MARKER_START) && content.includes(BADGE_MARKER_END);
}
