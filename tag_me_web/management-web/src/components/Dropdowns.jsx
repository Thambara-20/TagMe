import * as React from "react";
import { useTheme } from "@mui/material/styles";
import OutlinedInput from "@mui/material/OutlinedInput";
import InputLabel from "@mui/material/InputLabel";
import MenuItem from "@mui/material/MenuItem";
import FormControl from "@mui/material/FormControl";
import Select from "@mui/material/Select";

const ITEM_HEIGHT = 48;
const ITEM_PADDING_TOP = 8;
const MenuProps = {
  PaperProps: {
    style: {
      maxHeight: ITEM_HEIGHT * 4.5 + ITEM_PADDING_TOP,
      width: 250,
    },
  },
};

const Selecter = ({ text, onChange }) => {
  const [selectedValue, setSelectedValue] = React.useState([]);
  const defaultValue =
    text === "Year"
      ? new Date().getFullYear()
      : text === "Month"
      ? new Date().toLocaleString("default", { month: "long" })
      : "306A1";

  const handleChange = (event) => {
    setSelectedValue(event.target.value);
    onChange(event);
  };

  let names = [];

  // Populate names array based on the text prop
  if (text === "District") {
    names = ["306A1", "306A2", "306B1", "306B2", "306C1", "306C2"];
  } else if (text === "Month") {
    names = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
  } else if (text === "Year") {
    // Assuming you want to populate years from 2000 to the current year
    const currentYear = new Date().getFullYear();
    names = Array.from({ length: currentYear - 1999 }, (_, index) =>
      (2000 + index).toString()
    );
  }

  return (
    <div>
      <FormControl sx={{ m: 1, width: 300 }}>
        <InputLabel id="demo-multiple-name-label">{text}</InputLabel>
        <Select
          labelId="demo-multiple-name-label"
          id="demo-multiple-name"
          value={selectedValue}
          onChange={handleChange}
          input={<OutlinedInput label={text} />}
          MenuProps={MenuProps}
        >
          {names.map((name) => (
            <MenuItem key={name} value={name}>
              {name}
            </MenuItem>
          ))}
        </Select>
      </FormControl>
    </div>
  );
};

export default Selecter;
