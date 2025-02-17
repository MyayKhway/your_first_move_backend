/* eslint-disable  @typescript-eslint/no-explicit-any */

export class Car {
  private id?: number;
  private make: string;
  private model: string;
  private year: number;
  private fuel: string;
  private hp: number;
  private cylinders: number;
  private transmission: string;
  private wheelDrive: string;
  private doors: number;
  private category: string[];
  private size: string;
  private style: string;
  private hwMPG: number;
  private cityMPG: number;
  private msrp: number;

  constructor(
    make: string,
    model: string,
    year: number,
    fuel: string,
    hp: number,
    cylinders: number,
    transmission: string,
    wheelDrive: string,
    doors: number,
    category: string[],
    size: string,
    style: string,
    hwMPG: number,
    cityMPG: number,
    msrp: number,
    id?: number,
  ) {
    this.id = id;
    this.make = make;
    this.model = model;
    this.year = year;
    this.fuel = fuel;
    this.hp = hp;
    this.cylinders = cylinders;
    this.transmission = transmission;
    this.wheelDrive = wheelDrive;
    this.doors = doors;
    this.category = [...category];
    this.size = size;
    this.style = style;
    this.hwMPG = hwMPG;
    this.cityMPG = cityMPG;
    this.msrp = msrp;
  }

  getMake() {
    return this.make;
  }

  getModel() {
    return this.model;
  }

  getYear() {
    return this.year;
  }

  getfuel() {
    return this.fuel;
  }

  getHp() {
    return this.hp
  }

  getCylinders() {
    return this.cylinders;
  }

  getTransmission() {
    return this.transmission;
  }

  getDoors() {
    return this.doors;
  }

  getCategory() {
    return this.category;
  }

  getSize() {
    return this.size;
  }

  getStyle() {
    return this.style;
  }

  getHwMPG() {
    return this.hwMPG;
  }

  getCityMPG() {
    return this.cityMPG;
  }

  getMsrp() {
    return this.msrp;
  }

  toJSON(): Record<string, any> {
    return {
      make: this.make,
      model: this.model,
      year: this.year,
      fuel: this.fuel,
      hp: this.hp,
      cylinders: this.cylinders,
      transmission: this.transmission,
      wheelDrive: this.wheelDrive,
      doors: this.doors,
      category: this.category,
      size: this.size,
      style: this.style,
      hwMPG: this.hwMPG,
      cityMPG: this.cityMPG,
      msrp: this.msrp,
    };
  }
}
