std_msgs/Header header
string tag_id        # Unique Serial Number (UID)
string technology    # e.g., "NFC-A", "MifareClassic"
uint8[] ndef_payload # The raw data stored on the tag
